(local conform (require :conform))

(local by-ft {:lua [:stylua]
              :fennel [:fnlfmt]
              :ocaml [:ocamlformat]
              :go [:goimports :gofmt]
              :rust [:rustfmt-nightly]
              :javascript [:prettierd :prettier]
              :typescript [:prettierd :prettier]})

(local formatters
       {:rustfmt-nightly {:command :rustup :args [:run :nightly :rustfmt]}})

(fn setup []
  (conform.setup {:format_on_save {:timeout_ms 500 :lsp_fallback true}
                  :formatters_by_ft by-ft
                  :stop_after_first true
                  : formatters}))

{: setup}
