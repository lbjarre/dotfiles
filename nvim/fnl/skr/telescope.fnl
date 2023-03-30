;; skr.telescope
;; Setup for telescope related fuzzy search prompts.
(local tlscp (require :telescope))
(local builtin (require :telescope.builtin))
(local themes (require :telescope.themes))
(local previewers (require :telescope.previewers))

(local opt-timeout {:timeout 3000})

(fn merge [...]
  "Helper for merging tables."
  (vim.tbl_extend :force ...))

(lambda opts [?opt]
  (vim.tbl_extend :force {:timeout 3000} (or ?opt {})))

(lambda with-input [?prompt]
  {:search (vim.fn.input (or ?prompt "search: "))})

(fn map [mode key cmd]
  (vim.keymap.set mode key cmd {:remap false :silent true}))

(fn setup-keymaps []
  ;; Search files. Uses git-files first, with just all files if it isn't a git repo.
  ;; (<f>ind-<f>iles)
  (map :n :<leader>ff
       #(let [git-ok (pcall builtin.git_files {:hidden true})]
          (when (not git-ok)
            (builtin.find_files {:hidden true}))))
  ;; Search by grep.
  ;; (<f>ind-<g>rep)
  (map :n :<leader>fg #(builtin.live_grep (opts)))
  ;; Search in current buffer.
  ;; (<f>ind-/)
  (map :n :<leader>/
       #(builtin.current_buffer_fuzzy_find (themes.get_ivy {:layout_config {:prompt_position :top}
                                                            :sorting_strategy :ascending})))
  ;; Find by string. Lets you fuzzy search over the results.
  ;; (<f>ind-<s>tring
  (map :n :<leader>fs #(builtin.grep_string (opts (with-input))))
  ;; Find LSP symbols in workspace.
  ;; (<f>ind-<l>sp)
  (map :n :<leader>fl #(builtin.lsp_workspace_symbols (opts (with-input))))
  ;; Fuzzy search files in northvolt repos
  ;; (<f>ind-<n>orthvolt)
  (map :n :<leader>fn
       #(builtin.find_files (opts {:cwd "~/src/github.com/northvolt"
                                   :hidden true
                                   :file_ignore_patterns [:.*/.git/]})))
  ;; Find emojis
  ;; (<f>ind-<e>moji)
  (map :n :<leader>fe #(builtin.symbols (opts {:sources [:emoji]})))
  ;; Standard LSP hooks
  (map :n :gd #(builtin.lsp_definitions (opts)))
  (map :n :gr #(builtin.lsp_references (opts)))
  (map :n :gi #(builtin.lsp_implementations (opts)))
  ;; LSP namespaced finders
  ;; Diagnostics
  (map :n :<leader>ld #(builtin.diagnostics (opts)))
  ;; Symbols, but in the document.
  (map :n :<leader>ls #(builtin.lsp_document_symbols (opts))))

(fn setup []
  "Setup telescope with defaults."
  (tlscp.setup {:defaults {:vimgrep_arguments [:rg
                                               :--no-heading
                                               :--with-filename
                                               :--line-number
                                               :--column
                                               :--smart-case
                                               :--hidden]
                           :set_env {[:COLORTERM] :truecolor}
                           :file_previewer previewers.vim_buffer_cat.new
                           :grep_previewer previewers.vim_buffer_vimgrep.new
                           :qflist_previewer previewers.vim_buffer_qflist.new}
                :extensions {:ui-select {1 (themes.get_dropdown)}}})
  (tlscp.load_extension :noice)
  (tlscp.load_extension :ui-select)
  (setup-keymaps))

{: setup}
