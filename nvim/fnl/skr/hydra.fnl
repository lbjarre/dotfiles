(local hydra (require :hydra))
(local tlscp (require :skr.telescope))
(local gitsigns (require :gitsigns))

(fn hydra-git []
  (local hint "\n_J_: next hunk  _s_: stage hunk\n")
  (hydra {:name :Git
          : hint
          :config {:invoke_on_body true :hint {:border :rounded}}
          :on_enter #((gitsigns.toggle_signs true))
          :mode :n
          :body :<leader>g
          :heads [[:J
                   (fn []
                     (vim.schedule #((gitsigns.next_hunk)))
                     :<Ignore>)]
                  [:s ":Gitsigns stage_hunk<CR>"]]}))

(fn hydra-telescope []
  (hydra {:name :Telescope
          :config {:invoke_on_body true :hint {:type :window}}
          :mode :n
          :body :<leader>m
          :heads [[:f tlscp.files] [:n tlscp.files-nv]]}))

(fn setup []
  (hydra-git)
  (hydra-telescope))

{: setup}
