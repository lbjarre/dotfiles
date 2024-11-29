(local neo-tree (require :neo-tree))
(local cmd (require :neo-tree.command))

(fn toggle []
  (cmd.execute {:toggle true :position :left}))

(fn setup []
  (neo-tree.setup {:close_if_last_window true
                   :filesystem {;; Show hidden items by default
                                :filtered_items {:visible true}
                                ;; Update the filetree selection to the currently selected file
                                :follow_current_file {:enabled true}
                                ;; Listen on os events to automatically update the filetree
                                :use_libuv_file_watcher true}})
  (vim.keymap.set :n :<leader>t toggle {:desc "Toggle filetree"}))

{: setup}

