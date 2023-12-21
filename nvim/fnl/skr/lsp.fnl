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
                {:name :terraformls}
                {:name :cssls}])

(fn setup []
  ;; Create augroups
  (create-augroup :LspUserCfg {:clear true})

  (fn on_attach [client buf]
    "Defines the on_attach hook for the LSP client."
    (navic.attach client buf)
    (inlay-hints.on_attach client buf))

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

