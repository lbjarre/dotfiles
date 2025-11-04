(local luasnip (require :luasnip))
(local {: not-nil?} (require :skr.std))

(local filetypes [:all :go :nix])

(fn setup []
  (each [_ ft (ipairs filetypes)]
    (local pkg (require (.. :skr.snippets. ft)))
    (when (not-nil? pkg.setup)
      (pkg.setup))
    (luasnip.add_snippets ft pkg.snippets)))

{: setup}
