(local cmp (require :cmp))
(local luasnip (require :luasnip))

(fn setup []
  (let [snippet {:expand #(luasnip.lsp_expand $.body)}
        mapping (cmp.mapping.preset.insert {:<C-Space> (cmp.mapping.complete)})
        sources [{:name :nvim_lsp}
                 {:name :buffer}
                 {:name :path}
                 {:name :luasnip}]]
    (cmp.setup {: snippet : mapping : sources})))

{: setup}
