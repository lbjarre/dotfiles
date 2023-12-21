(local conform (require :conform))

(local by-ft {:lua [:stylua]
              :fennel [:fnlfmt]
              :go [:goimports :gofmt]
              :javascript [[:prettierd :prettier]]})

(fn setup []
  (conform.setup {:format_on_save {:timeout_ms 500 :lsp_fallback true}
                  :formatters_by_ft by-ft}))

{: setup}

