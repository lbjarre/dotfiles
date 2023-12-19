(local lsp-config (require :lspconfig))
(local navic (require :nvim-navic))
(local inlay-hints (require :lsp-inlayhints))

(local {:api {:nvim_buf_get_option buf-get-opt
              :nvim_create_augroup create-augroup
              :nvim_create_autocmd create-autocmd}
        :lsp {:buf {:format fmt}}
        :tbl_contains contains?} vim)

;; List of servers to enable: these are the server names as given in lspconfig.
(local servers [{:name :rust_analyzer}
                {:name :gopls
                 :settings {:gopls {:hints {:assignVariableTypes true
                                            :compositeLiteralFields true
                                            :constantValues true
                                            :functionTypeParameters true
                                            :parameterNames true
                                            :rangeVariableTypes true}}}}
                {:name :hls}
                {:name :ocamllsp}
                {:name :pylsp}
                {:name :lua_ls}
                {:name :erlangls}
                ; {:name :efm}
                {:name :terraformls}
                {:name :cssls}])

;; Lookup from filetype to which LSP features to enable in the on-attach hook.
(local ft-cfg {:go [:autofmt :inlay-hints]
               :rust [:autofmt :inlay-hints]
               :lua [:autofmt]
               :fennel [:autofmt]
               :haskell [:autofmt]
               :erlang [:autofmt]
               :typescript [:autofmt]
               :typescriptreact [:autofmt]
               :css [:autofmt]
               :ocaml [:autofmt]
               :terraform [:autofmt]
               :hcl [:autofmt]})

;; Lookup if a filetype has an attr set in the table above.
(fn has-cfg? [ft attr]
  (let [cfg (. ft-cfg ft)]
    (if cfg (contains? cfg attr) false)))

(fn setup []
  ;; Create augroups
  (create-augroup :LspAutofmt {:clear true})
  (create-augroup :LspUserCfg {:clear true})

  (fn attach-autocmd [client buf]
    ;; Filetype dependent setup.
    (local ft (buf-get-opt buf :filetype))
    ;; Set autoformatting.
    (when (has-cfg? ft :autofmt)
      (create-autocmd :BufWritePre
                      {:group :LspAutofmt :buffer buf :callback #(fmt)})))

  (fn on_attach [client buf]
    "Defines the on_attach hook for the LSP client."
    (navic.attach client buf)
    (inlay-hints.on_attach client buf)
    (attach-autocmd client buf))

  (create-autocmd :LspAttach
                  {:group :LspUserCfg
                   :callback (fn [ev]
                               (let [bufnr ev.buf
                                     client (vim.lsp.get_client_by_id ev.data.client_id)]
                                 (on_attach client bufnr)))})
  ;; Setup language specific things.
  (let [ts (require :typescript)]
    (ts.setup {:go_to_source_definition {:fallback true} :server {: on_attach}}))
  ;; Run the setup for each of the servers.
  (each [_ server (ipairs servers)]
    (let [{: name : settings} server
          srv (. lsp-config name)]
      (srv.setup {: settings}))))

{: setup}
