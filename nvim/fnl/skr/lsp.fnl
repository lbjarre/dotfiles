(local lsp-config (require :lspconfig))
(local navic (require :nvim-navic))

(local {:api {:nvim_buf_get_option buf-get-opt
              :nvim_create_augroup create-augroup
              :nvim_create_autocmd create-autocmd}
        :lsp {:buf {:format fmt}}
        :tbl_contains contains?} vim)

;; List of servers to enable: these are the server names as given in lspconfig.
(local servers [{:name :rust_analyzer}
                {:name :gopls
                 :settings {:gopls {:usePlaceholders true
                                    :hints {:assignVariableTypes true
                                            :compositeLiteralFields true
                                            :constantValues true
                                            :functionTypeParameters true
                                            :parameterNames true
                                            :rangeVariableTypes true}}}}
                {:name :hls}
                {:name :gleam}
                {:name :ocamllsp
                 :filetypes [:ocaml :reason :ocaml.mehir :ocaml.ocamllex]}
                {:name :pylsp}
                {:name :clangd :filetypes [:c :cpp]}
                {:name :lua_ls}
                {:name :denols
                 :root_dir (lsp-config.util.root_pattern :deno.json :deno.jsonc)}
                {:name :ts_ls
                 :root_dir (lsp-config.util.root_pattern :package.json)
                 :single_file_support false}
                {:name :erlangls}
                {:name :terraformls}
                {:name :jdtls}
                {:name :cssls}
                {:name :kotlin_language_server}
                {:name :yamlls}])

(fn setup []
  ;; Create augroups
  (create-augroup :LspUserCfg {:clear true})

  (fn on_attach [client buf]
    "Defines the on_attach hook for the LSP client."
    (navic.attach client buf))

  (create-autocmd :LspAttach
                  {:group :LspUserCfg
                   :callback (fn [ev]
                               (let [bufnr ev.buf
                                     client (vim.lsp.get_client_by_id ev.data.client_id)]
                                 (on_attach client bufnr)))})
  ;; Setup language specific things.
  (let [java (require :java)]
    (java.setup))
  ;; Run the setup for each of the servers.
  (each [_ server (ipairs servers)]
    (let [{: name &as cfg} server
          srv (. lsp-config name)]
      (srv.setup cfg))))

{: setup}
