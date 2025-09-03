(local navic (require :nvim-navic))

(local {:api {:nvim_create_augroup create-augroup
              :nvim_create_autocmd create-autocmd}} vim)

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
  ;; Rust
  (vim.lsp.enable :rust_analyzer)
  ;; Go
  (vim.lsp.config :gopls
                  {:settings {:gopls {:usePlaceholders true
                                      :hints {:assignVariableTypes true
                                              :compositeLiteralFields true
                                              :constantValues true
                                              "functionTypeParameters:" true
                                              :parameterNames true
                                              :rangeVariableTypes true}}}})
  (vim.lsp.enable :gopls)
  ;; Haskell
  (vim.lsp.enable :hls)
  ;; Gleam
  (vim.lsp.enable :gleam)
  ;; OCaml
  (vim.lsp.enable :ocamllsp)
  ;; Lua
  (vim.lsp.enable :lua_ls)
  ;; Fennel
  (vim.lsp.enable :fennel_ls)
  ;; C, C++
  (vim.lsp.config :clangd {:filetypes [:c :cpp]})
  (vim.lsp.enable :clangd)
  ;; Erlang
  (vim.lsp.enable :erlangls)
  ;; Terraform
  (vim.lsp.enable :terraformls)
  ;; CSS
  (vim.lsp.enable :cssls)
  ;; Kotlin
  (vim.lsp.enable :kotlin_language_server)
  ;; YAML
  (vim.lsp.enable :yamlls)
  ;; Zig
  (vim.lsp.enable :zls)
  ;; Nix
  (vim.lsp.config :nil_ls {:settings {:nil {:formatting {:command [:nixfmt]}}}})
  (vim.lsp.enable :nil_ls)
  ;; Python
  (vim.lsp.config :ty {:cmd [:uvx :ty :server]})
  (vim.lsp.enable :ty)
  ;; Deno
  (vim.lsp.enable :denols)
  ;; Node
  (vim.lsp.config :ts_ls {:single_file_support false})
  (vim.lsp.enable :ts_ls)
  ;; Shell
  (vim.lsp.enable :bashls))

{: setup}
