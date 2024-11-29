;; skr.telescope
;; Setup for telescope related fuzzy search prompts.
(local tlscp (require :telescope))
(local builtin (require :telescope.builtin))
(local themes (require :telescope.themes))
(local previewers (require :telescope.previewers))
(local actions (require :telescope.actions))
(local action-state (require :telescope.actions.state))

(local {: nil?} (require :skr.std))

(local opt-timeout {:timeout 3000})

(fn merge [...]
  "Helper for merging tables."
  (vim.tbl_extend :force ...))

(lambda opts [?opt]
  (vim.tbl_extend :force {:timeout 3000} (or ?opt {})))

(lambda with-input [?prompt]
  {:search (vim.fn.input (or ?prompt "search: "))})

(lambda map [mode key cmd ?desc]
  (vim.keymap.set mode key cmd {:remap false :silent true :desc ?desc}))

(fn buffer/force-delete [bufnr]
  "API wrapper for nvim_buf_delete, with {force=true} option."
  (vim.api.nvim_buf_delete bufnr {:force true}))

(fn delete-buffer-mapping [prompt-bufnr]
  "Prompt mapping to delete buffers from the selection."
  (let [multi-selections (-> prompt-bufnr
                             (action-state.get_current_picker)
                             (: :get_multi_selection))]
    (if (nil? (next multi-selections))
        (let [{: bufnr} (action-state.get_selected_entry)]
          (buffer/force-delete bufnr))
        (each [_ {: bufnr} (ipairs multi-selections)]
          (buffer/force-delete bufnr)))
    (actions.close prompt-bufnr)))

(fn search-files []
  "Picker for files."
  (let [opts {:hidden true}]
    (when (not (pcall tlscp.extensions.jj.files opts))
      (when (not (pcall builtin.git_files opts))
        (builtin.find_files opts)))))

(fn setup-keymaps []
  ;; Search files. Tries VCS files first (Jujutsu, Git), falling back on just all files if they fail.
  ;; (<f>ind-<f>iles)
  (map :n :<leader>ff search-files "Find files")
  ;; Search by grep.
  ;; (<f>ind-<g>rep)
  (map :n :<leader>fg #(builtin.live_grep (opts)) "Find grep")
  ;; Search in current buffer.
  ;; (<f>ind-/)
  (map :n :<leader>/
       #(builtin.current_buffer_fuzzy_find (themes.get_ivy {:layout_config {:prompt_position :top}
                                                            :sorting_strategy :ascending}))
       "Find in buffer")
  ;; Find by string. Lets you fuzzy search over the results.
  ;; (<f>ind-<s>tring
  (map :n :<leader>fs #(builtin.grep_string (opts (with-input)))
       "Find by string")
  ;; Find buffers, with extra mapping to close buffers from the picker.
  ;; (<f>ind-<b>uffers)
  (map :n :<leader>fb
       #(builtin.buffers (opts {:attach_mappings (fn [prompt-bufnr map]
                                                   (map :i :<C-d>
                                                        #(delete-buffer-mapping prompt-bufnr))
                                                   true)}))
       "Find buffers")
  ;; Find LSP symbols in workspace.
  ;; (<f>ind-<l>sp)
  (map :n :<leader>fl #(builtin.lsp_workspace_symbols (opts (with-input)))
       "Find LSP symbol")
  ;; Fuzzy search files in northvolt repos
  ;; (<f>ind-<n>orthvolt)
  (map :n :<leader>fn
       #(builtin.find_files (opts {:cwd "~/src/github.com/northvolt"
                                   :hidden true
                                   :file_ignore_patterns [:.*/.git/]}))
       "Find Northvolt repo")
  ;; Find emojis
  ;; (<f>ind-<e>moji)
  (map :n :<leader>fe #(builtin.symbols (opts {:sources [:emoji]}))
       "Find emoji")
  ;; Greek letters
  ;; (<gr>eek)
  (map :n :<leader>gr #(builtin.symbols (opts {:sources [:greek]}))
       "Find greek letter")
  ;; Standard LSP hooks
  (map :n :gd #(builtin.lsp_definitions (opts)) "Goto definition")
  (map :n :gr #(builtin.lsp_references (opts)) "Goto references")
  (map :n :gi #(builtin.lsp_implementations (opts)) "Goto implementations")
  ;; LSP namespaced finders
  ;; Diagnostics
  (map :n :<leader>ld #(builtin.diagnostics (opts)) "Find diagnostic")
  ;; Symbols, but in the document.
  (map :n :<leader>ls #(builtin.lsp_document_symbols (opts)) "Find symbol"))

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
  ;; Load extensions.
  (tlscp.load_extension :jj)
  (tlscp.load_extension :noice)
  (tlscp.load_extension :ui-select)
  ;; Setup keymaps.
  (setup-keymaps))

{: setup}
