(local lsp-config (require :lspconfig))
(local inlay-hints (require :lsp_extensions.inlay_hints))
(local navic (require :nvim-navic))
(local null-ls (require :null-ls))

(local {:api {:nvim_buf_get_option buf-get-opt
              :nvim_create_augroup create-augroup
              :nvim_create_autocmd create-autocmd}
        :lsp {:buf {:format fmt}}
        :tbl_contains contains?} vim)

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

(local ft-cfg {:go              [:autofmt :inlay-hints] ;; todo: inlay-hints, deprecated lsp_extensions does not work for gopls
               :rust            [:autofmt :inlay-hints]
               :haskell         [:autofmt]
               :typescript      [:autofmt]
               :typescriptreact [:autofmt]
               :ocaml           [:autofmt]
               :terraform       [:autofmt]
               :hcl             [:autofmt]})

(fn has-cfg? [ft attr]
  (let [cfg (. ft-cfg ft)]
    (if cfg
        (contains? cfg attr)
        false)))

(fn set-inlay-hints []
  "Enable inlay-hints for the current buffer.

  TODO: the repo for this is archived, probably should inline this in my repo
  instead of using the upstream."
  (inlay-hints.request {:aligned true
                        :prefix  " » "}))

(fn setup-null-ls []
  "Sets up the null-ls sources."
  (local {:builtins {:formatting fmt
                     :diagnostics dgn
                     :code_actions act}} null-ls)

  (local sources [fmt.prettierd
                  fmt.eslint
                  dgn.eslint
                  act.eslint
                  dgn.shellcheck
                  act.shellcheck
                  dgn.golangci_lint])

  (null-ls.setup {: sources}))

(fn setup []
  (create-augroup :LspInlayHints {:clear true})
  (create-augroup :LspAutofmt {:clear true})

  ;; Setup null-ls sources.
  (setup-null-ls)

  ;; Create the on-attach callback.
  (fn on-attach [client buf]
    ;; Attach exensions
    (navic.attach client buf)

    ;; Filetype dependent setup.
    (local ft (buf-get-opt buf :filetype))
    ;; Set inlay hints.
    (when (has-cfg? ft :inlay-hints)
      (create-autocmd [:BufEnter
                       :BufWritePost] {:group :LspInlayHints
                                       :buffer buf
                                       :callback #(set-inlay-hints)}))
    ;; Set autoformatting.
    (when (has-cfg? ft :autofmt)
      (create-autocmd :BufWritePre {:group :LspAutofmt
                                    :buffer buf
                                    :callback #(fmt)})))

  ;; Run the setup for each of the servers.
  (local opts {:on_attach on-attach})
  (each [_ server (ipairs servers)]
    (let [{: setup} (. lsp-config server)]
      (setup opts))))

{: setup}
