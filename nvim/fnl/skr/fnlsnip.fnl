(local ls (require :luasnip))

(local filetypes [:all
                  :go])

(fn require-snip [ft]
  "require the snippets module and gets the `.snippets` key"
  (local path (.. :skr.snippets. ft))
  (. (require path) :snippets))

(local snippets
  (collect [_ ft (ipairs filetypes)]
    ft (require-snip ft)))

(fn setup []
  (each [_ ft (ipairs filetypes)]
    (ls.add_snippets ft (require-snip ft))))

{: setup}
