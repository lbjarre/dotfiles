(local {:api {:nvim_create_augroup create-augroup
              :nvim_create_autocmd create-autocmd}
        :highlight {:on_yank hl-on-yank}} vim)

(fn setup []
  "Setup options."
  (local opt vim.opt)
  ;; Looks.
  (set opt.background :dark)
  (set opt.termguicolors true)
  ;; Add colored indications on col 80 and 100.
  (set opt.colorcolumn [80 100])
  ;; Whitespace characters.
  (set opt.showbreak "↪")
  (set opt.list true)
  (set opt.listchars {:tab "→ "
                      :eol "↲"
                      :nbsp "␣"
                      :trail "•"
                      :extends "⟩"
                      :precedes "⟨"})
  ;; Don't use backups/swapfiles.
  (set opt.swapfile false)
  (set opt.backup false)
  (set opt.writebackup false)
  (set opt.hidden true)
  (set opt.showcmd true)
  (set opt.autoindent true)
  (set opt.startofline false)
  ;; Default tab setup.
  (set opt.shiftwidth 4)
  (set opt.softtabstop 4)
  (set opt.expandtab true)
  ;; Alllow mouse usage, even though it brings shame to my family name.
  (set opt.mouse :a)
  ;; Left column.
  (set opt.number true)
  (set opt.relativenumber true)
  (set opt.signcolumn :yes)
  ;; Sensible splits.
  (set opt.splitright true)
  (set opt.splitbelow true)
  ;; Timeouts for sequences.
  (set opt.timeoutlen 500)
  (set opt.ttimeoutlen 10)
  ;; Visual stuff: don't show the mode in the command line since I have it in the statusline.
  (set opt.showmode false)
  ;; Autocomplete options, don't allow for willy nilly inserts without me telling it to.
  (set opt.completeopt "menu,menuone,noinsert")
  ;; Status lines.
  ;; Statusline eval from separate module (fnl/skr/statuslime.fnl).
  (set opt.statusline "%!luaeval(\"require('skr.statuslime').statusline()\")")
  (set opt.winbar "%f")
  (set opt.laststatus 3)
  ;; Set global statusline for the entire screen.
  ;; Startify.
  ;; TODO: should be able to rewrite this myself?
  (set vim.g.startify_lists
       [{:type :dir :header [(.. "  MRU " (vim.fn.getcwd))]}])
  (set vim.g.startify_change_to_dir 0)
  ;; Create an autocommand for highlighting what you yank.
  (create-augroup :Yank {:clear true})
  (create-autocmd :TextYankPost {:group :Yank :callback #(hl-on-yank)}))

{: setup}
