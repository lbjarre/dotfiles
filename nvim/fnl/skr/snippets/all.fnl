(local ls (require :luasnip))
(local t ls.text_node)
(local i ls.insert_node)
(local c ls.choice_node)
(local f ls.function_node)
(local fmt (. (require :luasnip.extras.fmt) :fmt))

(local snippet-todo
  (let [choices [(t "TODO(lb): ")
                 (t "FIXME(lb): ")
                 (t "NOTE(lb): ")]
        root (fmt "{}" (c 1 choices))]
    (ls.snippet "todo" root)))

(local snippet-now
  (let [get-date #(os.date "%Y-%m%-dT%H:%M:%S")
        root (f get-date)]
    (ls.snippet "now" root)))

{:snippets [snippet-todo
            snippet-now]}
