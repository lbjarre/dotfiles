(local {:setup smart-splits/setup
        :resize_left resize-left
        :resize_right resize-right
        :resize_up resize-up
        :resize_down resize-down
        :move_cursor_left move-cursor-left
        :move_cursor_right move-cursor-right
        :move_cursor_up move-cursor-up
        :move_cursor_down move-cursor-down} (require :smart-splits))

(local bufresize (require :bufresize))

(fn map [mode key cmd]
  (vim.keymap.set mode key cmd {:remap false :silent true}))

(fn setup-keymaps []
  ;; Resizing splits
  (map :n :<A-h> resize-left)
  (map :n :<A-j> resize-down)
  (map :n :<A-k> resize-up)
  (map :n :<A-l> resize-right)
  ;; Move between splits
  (map :n :<C-h> move-cursor-left)
  (map :n :<C-j> move-cursor-down)
  (map :n :<C-k> move-cursor-up)
  (map :n :<C-l> move-cursor-right))

(fn setup []
  (smart-splits/setup {:silent true :on_leave #(bufresize.register)})
  (setup-keymaps))

{: setup}
