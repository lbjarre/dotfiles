(local lsp-config (require :lspconfig))
(local inlay-hints (require :lsp_extensions.inlay_hints))
(local navic (require :nvim-navic))
(local null-ls (require :null-ls))

(local {:api {:nvim_buf_get_option buf-get-opt
              :nvim_create_augroup create-augroup
              :nvim_create_autocmd create-autocmd}
        :lsp {:buf {:format fmt}}
        :tbl_contains contains?} vim)

;; List of servers to enable: these are the server names as given in lspconfig.
(local servers [:rust_analyzer
                :gopls
                :hls
                :ocamllsp
                :pylsp
                :lua_ls
                :tsserver
                :graphql
                :terraformls
                :cssls])

;; Lookup from filetype to which LSP features to enable in the on-attach hook.
(local ft-cfg {:go [:autofmt :inlay-hints]
               ;; todo: inlay-hints, deprecated lsp_extensions does not work for gopls
               :rust [:autofmt :inlay-hints]
               :lua [:autofmt]
               :fennel [:autofmt]
               :haskell [:autofmt]
               :typescript [:autofmt]
               :typescriptreact [:autofmt]
               :css [:autofmt]
               :ocaml [:autofmt]
               :terraform [:autofmt]
               :hcl [:autofmt]})

;; Lookup if a filetype has an attr set in the table above.
(fn has-cfg? [ft attr]
  (let [cfg (. ft-cfg ft)]
    (if cfg
        (contains? cfg attr) false)))

(fn set-inlay-hints []
  "Enable inlay-hints for the current buffer.

  TODO: the repo for this is archived, probably should inline this in my repo
  instead of using the upstream."
  (inlay-hints.request {:aligned true :prefix " » "}))

(fn setup []
  ;; Create augroups
  (create-augroup :LspInlayHints {:clear true})
  (create-augroup :LspAutofmt {:clear true})

  (fn on-attach [client buf]
    "Defines the on_attach hook for the LSP client."
    ;; Attach exensions
    (navic.attach client buf)
    ;; Filetype dependent setup.
    (local ft (buf-get-opt buf :filetype))
    ;; Set inlay hints.
    (when (has-cfg? ft :inlay-hints)
      (create-autocmd [:BufEnter :BufWritePost]
                      {:group :LspInlayHints
                       :buffer buf
                       :callback #(set-inlay-hints)}))
    ;; Set autoformatting.
    (when (has-cfg? ft :autofmt)
      (create-autocmd :BufWritePre
                      {:group :LspAutofmt :buffer buf :callback #(fmt)})))

  ;; Setup null-ls.
  (let [{:builtins {:formatting fmt :diagnostics dgn :code_actions act}} null-ls
        sources [fmt.prettierd
                 fmt.eslint_d
                 dgn.eslint_d
                 act.eslint_d
                 dgn.shellcheck
                 act.shellcheck
                 fmt.stylua
                 fmt.fnlfmt]
        opts {: sources :on_attach on-attach}]
    (null-ls.setup opts))
  ;; Run the setup for each of the servers.
  (local opts {:on_attach on-attach})
  (each [_ server (ipairs servers)]
    (let [{: setup} (. lsp-config server)]
      (setup opts))))

{: setup}
