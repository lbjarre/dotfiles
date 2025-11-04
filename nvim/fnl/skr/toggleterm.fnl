(local toggleterm (require :toggleterm))

(local {:api {:nvim_create_augroup create-augroup
              :nvim_create_autocmd create-autocmd}} vim)

(fn setup-autocmd [group]
  "Attach autocommands to the terminal buffer, in the augroup :group."
  (fn autocmd-enter []
    ;; Setup keymaps: all should be buffer local.
    (local opts {:buffer 0})
    ;; Keymap for exiting out of term-mode. The default out (<C-\><C-n>) is a bit
    ;; too obscure for my taste, so I wish to have it closer to other modes (<esc>).
    ;; However, just <esc> does't work either for two reasons:
    ;;
    ;;  - zsh uses <esc> for entering vi mode for editing the line buffer.
    ;;  - I use nvim for commit messages inside these term buffers, and I need
    ;;    to be able to switch mode in that embedded nvim instance without
    ;;    interacting with the host nvim.
    ;;
    ;; For these reasons I use <esc><esc> instead.
    (vim.keymap.set :t :<esc><esc> "<C-\\><C-n>" opts))

  (create-augroup group {:clear true})
  (create-autocmd :TermOpen
                  {: group :pattern ["term://*"] :callback autocmd-enter}))

(fn setup-keymaps []
  "Set keymaps related to toggleterm actions."
  (local opts {:noremap true :silent true})
  ;; Keymap for toggling the terminal on and off.
  (vim.keymap.set [:n :t] "<C-\\>" #(toggleterm.toggle_command "" 0) opts))

(fn setup []
  "Setup toggleterm config and bindings."
  ;; Setup the package itself.
  (toggleterm.setup {:direction :vertical
                     :size #(case $1.direction
                              :horizontal 20
                              :vertical (* vim.o.columns 0.33))})
  ;; Setup autocommands which attaches on "TermOpen", local only to the term buffer.
  (setup-autocmd :ToggleTerm)
  ;; ... and some toggleterm specific keymaps.
  (setup-keymaps))

{: setup}
