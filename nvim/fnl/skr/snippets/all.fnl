(local {:snippet mk-snippet
        :text_node t
        :insert_node i
        :choice_node c
        :function_node f} (require :luasnip))

(local {: fmt} (require :luasnip.extras.fmt))

(local snippet-todo (let [choices [(t "TODO(lb): ")
                                   (t "FIXME(lb): ")
                                   (t "NOTE(lb): ")]
                          root (fmt "{}" (c 1 choices))]
                      (mk-snippet :todo root)))

(local snippet-now (let [get-date #(os.date "%Y-%m-%dT%H:%M:%S")
                         root (f get-date)]
                     (mk-snippet :now root)))

{:snippets [snippet-todo snippet-now]}
