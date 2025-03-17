(local {:setup term/setup :toggle_command term/toggle-cmd}
       (require :toggleterm))

(local {:keymap {:set set-keymap}
        :api {:nvim_create_augroup create-augroup
              :nvim_create_autocmd create-autocmd}} vim)

(fn setup-autocmd [group]
  "Attach autocommands to the terminal buffer, in the augroup :group."
  (fn toggle-number []
    "Toggle line numbering and signcolumn"
    (macro toggle! [target invert]
      `(set ,target (,invert ,target)))
    (toggle! vim.wo.number not)
    (toggle! vim.wo.relativenumber not)
    (toggle! vim.wo.signcolumn #(match $1
                                  :no :yes
                                  :yes :no)))

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
    (set-keymap :t :<esc><esc> "<C-\\><C-n>" opts)
    ;; Keymap for toggling line numbering in the buffer.
    (set-keymap :n :<leader>n toggle-number opts)
    ;; Set line numbering off by default when entering.
    (set vim.wo.number false)
    (set vim.wo.relativenumber false)
    (set vim.wo.signcolumn :no))

  (create-augroup group {:clear true})
  (create-autocmd :TermOpen
                  {: group :pattern ["term://*"] :callback autocmd-enter}))

(fn setup-keymaps []
  "Set keymaps related to toggleterm actions."
  (local opts {:noremap true :silent true})
  ;; Keymap for toggling the terminal on and off.
  (set-keymap [:n :t] "<C-\\>" #(term/toggle-cmd "" 0) opts))

(fn setup []
  "Setup toggleterm config and bindings."
  ;; Setup the package itself.
  (term/setup {:direction :vertical
               :size #(match $1.direction
                        :horizontal 20
                        :vertical (* vim.o.columns 0.33))})
  ;; Setup autocommands which attaches on "TermOpen", local only to the term buffer.
  (setup-autocmd :ToggleTerm)
  ;; ... and some toggleterm specific keymaps.
  (setup-keymaps))

{: setup}
