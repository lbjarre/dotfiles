(local cmp (require :cmp))
(local luasnip (require :luasnip))

(local icons {:Text ""
              :Method ""
              :Function ""
              :Constructor ""
              :Field ""
              :Variable ""
              :Class ""
              :Interface ""
              :Module ""
              :Property "ﰠ"
              :Unit ""
              :Value ""
              :Enum ""
              :Keyword ""
              :Snippet ""
              :Color ""
              :File ""
              :Reference ""
              :Folder ""
              :EnumMember ""
              :Constant ""
              :Struct ""
              :Event ""
              :Operator ""
              :TypeParameter ""})

(local src-menus {:buffer :BUF :nvim_lsp :LSP :luasnip :SNIP :path :PATH})

(fn format [entry vim-item]
  (let [icon (. icons vim-item.kind)
        kind (string.format "%s %s" icon vim-item.kind)
        menu (. src-menus entry.source.name)]
    (do
      (set vim-item.kind kind)
      (set vim-item.menu menu)
      vim-item)))

(local src {:path {:name :path}
            :buffer {:name :buffer}
            :luasnip {:name :luasnip}
            :cmdline {:name :cmdline}
            :lsp {:name :nvim_lsp}
            :lsp-signature-help {:name :nvim_lsp_signature_help}})

(fn setup []
  (cmp.setup {:snippet {:expand #(luasnip.lsp_expand $.body)}
              :mapping (cmp.mapping.preset.insert {:<C-Space> (cmp.mapping.complete)})
              :sources (cmp.config.sources [src.lsp
                                            src.buffer
                                            src.path
                                            src.luasnip
                                            src.lsp-signature-help])
              :formatting {: format}
              :window {:completion (cmp.config.window.bordered)
                       :documentation (cmp.config.window.bordered)}})
  (cmp.setup.cmdline ":"
                     {:mapping (cmp.mapping.preset.cmdline)
                      :sources (cmp.config.sources [src.cmdline src.path])})
  (cmp.setup.cmdline "/"
                     {:mapping (cmp.mapping.preset.cmdline)
                      :sources (cmp.config.sources [src.buffer])}))

{: setup}
