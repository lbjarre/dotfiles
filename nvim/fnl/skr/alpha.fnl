(local alpha (require :alpha))
(local dashboard (require :alpha.themes.dashboard))

(local buttons
       [(dashboard.button :e "  New file" ":enew<CR>")
        (dashboard.button "SPC f f" "  Find file")
        (dashboard.button :q "  Quit NVIM" ":qa<CR>")])

(fn setup []
  (set dashboard.section.buttons.val buttons)
  (alpha.setup dashboard.config))

{: setup}
