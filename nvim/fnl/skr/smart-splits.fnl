(local smart-splits (require :smart-splits))

(fn map [mode key cmd]
  (vim.keymap.set mode key cmd {:remap false :silent true}))

(fn setup []
  (smart-splits.setup {:log {:file false}})
  ;; Resizing splits
  (map :n :<A-h> smart-splits.resize_left)
  (map :n :<A-j> smart-splits.resize_down)
  (map :n :<A-k> smart-splits.resize_up)
  (map :n :<A-l> smart-splits.resize_right)
  ;; Move between splits
  (map :n :<C-h> smart-splits.move_cursor_left)
  (map :n :<C-j> smart-splits.move_cursor_down)
  (map :n :<C-k> smart-splits.move_cursor_up)
  (map :n :<C-l> smart-splits.move_cursor_right))

{: setup}
