(fn import-tbl [path tbl]
  "Creates an 'import-table', which stores information about the path it was
  imported from. Getting an item out from that table will return another table
  with the .path and .name keys set, which can be used to determine the import
  string for the given item."
  (setmetatable
    {:__table tbl
     :__path path}
    {:__index (fn [tbl key]
                (if (= key :__path)
                  (. tbl :__path)
                  {: path
                   :name key
                   :value (. tbl :__table key)}))}))

(fn import [path]
  "Import a module and store info about the importing. Use instead of 'require'
  in this module to get the mapping to work."
  (import-tbl path (require path)))

(fn map [mode key cmd]
  "Set a keymap. Hardcoded to nnoremap and with silent=true atm."
  (let [cmd-esc (match (type cmd)
                  ;; strings just pass through
                  :string cmd
                  ;; tables -> check if it is an import table
                  :table (match cmd
                           {: path : name : value}
                           (.. "<cmd>lua require('" path "')." name "()<cr>")
                           _ nil))]
    (vim.api.nvim_set_keymap
      mode key cmd-esc
      {:noremap true :silent true})))

(fn nmap [key cmd]
  (map :n key cmd))

(fn vmap [key cmd]
  (map :v key cmd))

(local skr-tlscp (import :skr.telescope))
(local tlscp     (import :telescope.builtin))
(local lsp-diag  (import :vim.lsp.diagnostic))
(local lsp-buf   (import :vim.lsp.buf))
(local dap       (import :dap))
(local dapui     (import :dapui))

;; Clipboard yank/pasting
(nmap :<leader>y "\"*y")
(vmap :<leader>y "\"*y")
(nmap :<leader>p "\"*p")
(nmap :<leader>P "\"*P")

;; Telescope
(nmap :<leader>ff skr-tlscp.files)
(nmap :<leader>fg tlscp.live_grep)
(nmap "<leader>/" skr-tlscp.search_buf)
(nmap :<leader>fs skr-tlscp.grep_string)
(nmap :<leader>fl skr-tlscp.lsp_workspace_symbols)

;; LSP
(nmap :dn         lsp-diag.goto_next)
(nmap :dp         lsp-diag.goto_prev)
(nmap :K          lsp-buf.hover)
(nmap :<leader>la skr-tlscp.lsp_code_actions)
(nmap :gd         skr-tlscp.lsp_def)
(nmap :gr         skr-tlscp.lsp_ref)
(nmap :gi         skr-tlscp.lsp_impl)
(nmap :<leader>ld skr-tlscp.lsp_ws_diagnostics)
(nmap :<leader>ls skr-tlscp.lsp_doc_symbols)
(nmap :<leader>lr lsp-buf.rename)

;; DAP
(nmap :<leader>db dap.toggle_breakpoint)
(nmap :<leader>dc dap.continue)
(nmap :<leader>ds dap.step_over)
(nmap :<leader>du dapui.toggle)

