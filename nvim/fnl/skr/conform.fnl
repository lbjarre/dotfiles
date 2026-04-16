(local conform (require :conform))

(local by-ft {:lua [:stylua]
              :fennel [:fnlfmt]
              :ocaml [:ocamlformat]
              :go [:goimports :gofmt]
              :javascript [:prettierd :prettier]
              :yaml [:yamlfmt]})

(fn setup []
  (conform.setup {:format_on_save {:timeout_ms 500 :lsp_fallback true}
                  :formatters_by_ft by-ft
                  :stop_after_first true}))

{: setup}
