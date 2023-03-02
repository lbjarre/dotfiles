(local luasnip (require :luasnip))

(local filetypes [:all :go])

(fn require-snip [ft]
  "require the snippets module and gets the `.snippets` key"
  (local path (.. :skr.snippets. ft))
  (. (require path) :snippets))

(fn setup-ft [ft]
  (local path (.. :skr.snippets. ft))
  (local setup (. (require path) :setup))
  (when setup
    (setup)))

(local snippets (collect [_ ft (ipairs filetypes)]
                  ft
                  (require-snip ft)))

(fn setup []
  (each [_ ft (ipairs filetypes)]
    (local pkg (require (.. :skr.snippets. ft)))
    (when (not= pkg.setup nil)
      (pkg.setup))
    (luasnip.add_snippets ft pkg.snippets)))

{: setup}
