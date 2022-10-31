(local lsp-config (require :lspconfig))
(local inlay-hints (require :lsp_extensions.inlay_hints))
(local navic (require :nvim-navic))

(local {:api {:nvim_buf_get_option buf-get-opt
              :nvim_create_augroup create-augroup
              :nvim_create_autocmd create-autocmd}
        :lsp {:buf {:format fmt}}
        :tbl_contains contains?} vim)

(local servers [:rust_analyzer
                :gopls
                :hls
                :pylsp
                :sumneko_lua
                :tsserver
                :graphql
                :terraformls
                :cssls])

(local ft-autofmt [:go
                   :rust
                   :haskell
                   :typescript
                   :typescriptreact
                   :terraform
                   :hcl])

(fn set-inlay-hints []
  "Enable inlay-hints for the current buffer.

  TODO: the repo for this is archived, probably should inline this in my repo
  instead of using the upstream."
  (inlay-hints.request {:aligned true
                        :prefix  " » "}))

(fn setup []
  (create-augroup :LspInlayHints {:clear true})
  (create-augroup :LspAutofmt {:clear true})

  (fn on-attach [client buf]
    ;; Attach exentsions
    (navic.attach client buf)

    ;; Filetype dependent setup.
    (local ft (buf-get-opt buf :filetype))
    ;; Set inlay hints.
    (when (= ft :rust)
      (create-autocmd [:BufEnter
                       :BufWritePost] {:group :LspInlayHints
                                       :buffer buf
                                       :callback #(set-inlay-hints)}))
    ;; Set autoformatting.
    (when (contains? ft-autofmt ft)
      (create-autocmd :BufWritePre {:group :LspAutofmt
                                    :buffer buf
                                    :callback #(fmt)})))

  ;; Run the setup for each of the servers.
  (local opts {:on_attach on-attach})
  (each [_ server (ipairs servers)]
    (let [{: setup} (. lsp-config server)]
      (setup opts))))

{: setup}
