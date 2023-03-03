(fn setup []
  (fn snippet/expand [{: body}]
    (let [luasnip (require :luasnip)]
      (luasnip.lsp_expand body)))

  (let [cmp (require :cmp)
        snippet {:expand snippet/expand}
        mapping (cmp.mapping.preset.insert {:<C-Space> (cmp.mapping.complete)})
        sources [{:name :nvim_lsp}
                 {:name :buffer}
                 {:name :path}
                 {:name :luasnip}]
        config {: snippet : mapping : sources}]
    (cmp.setup config)))

{: setup}
