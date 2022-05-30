;; skr.telescope-fnl
;; Exported functions for telescope related fuzzy search prompts.
(local tlscp      (require :telescope))
(local builtin    (require :telescope.builtin))
(local themes     (require :telescope.themes))
(local previewers (require :telescope.previewers))

(local opt-timeout {:timeout 3000})

(fn merge [...]
  "Helper for merging tables."
  (vim.tbl_extend :force ...))

(local vimgrep-arg ["rg" "--no-heading" "--with-filename"
                    "--line-number" "--column" "--smart-case" "--hidden"])

(fn setup []
  "Setup telescope with defaults."
  (tlscp.setup {:defaults {:vimgrep_arguments vimgrep-arg
                           :set_env {[:COLORTERM] "truecolor"}
                           :file_previewer previewers.vim_buffer_cat.new
                           :grep_previewer previewers.vim_buffer_vimgrep.new
                           :qflist_previewer previewers.vim_buffer_qflist.new}}))

(fn files []
  "Fuzzy find files by file name.
   Tries first to check for git files if we are in a git repo, else will just
   do files as given by rg."
  (local args {:hidden true})
  (local git-ok (pcall builtin.git_files args))
  (when (not git-ok)
    (builtin.find_files args)))

(fn search-buf []
  "Fuzzy find content in the buffer."
  (builtin.current_buffer_fuzzy_find
    (themes.get_ivy {:layout_config {:prompt_position :top}
                     :sorting_strategy :ascending})))

(fn grep-string []
  "Fuzzy find for arbitrary text."
  (builtin.grep_string (merge opt-timeout {:search (vim.fn.input "search: ")})))

(fn diagnostics []
  "Fuzzy find over diagnostics."
  (builtin.diagnostics opt-timeout))

(fn lsp-workspace-symbols []
  "Fuzzy find LSP workspace symbols."
  (builtin.lsp_workspace_symbols (merge opt-timeout {:query (vim.fn.input "search: ")})))

(fn lsp-def []
  "Fuzzy find LSP definitions on current symbol."
  (builtin.lsp_definitions opt-timeout))

(fn lsp-ref []
  "Fuzzy find LSP references on current symbol."
  (builtin.lsp_references opt-timeout))

(fn lsp-impl []
  "Fuzzy find LSP implementations on current symbol."
  (builtin.lsp_implementations opt-timeout))

(fn lsp-doc-symbols []
  "Fuzzy find LSP symbols in current document."
  (builtin.lsp_document_symbols opt-timeout))

{: setup
 : files
 : search-buf
 : grep-string
 : diagnostics
 : lsp-workspace-symbols
 : lsp-def
 : lsp-ref
 : lsp-impl
 : lsp-doc-symbols}
