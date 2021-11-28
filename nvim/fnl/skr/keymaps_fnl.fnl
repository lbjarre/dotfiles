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

(fn map [key cmd]
  "Set a keymap. Hardcoded to nnoremap and with silent=true atm."
  (let [cmd-esc (match (type cmd)
                  ;; strings just pass through
                  :string cmd
                  ;; tables -> check if it is an import table
                  :table (match cmd
                           {: path : name : value}
                           (.. "<cmd>lua require('" path "')." name "()<cr>" )
                           _ nil))]
    (vim.api.nvim_set_keymap
      :n key cmd-esc
      {:noremap true :silent true})))

(local skr-tlscp (import :skr.telescope))
(local tlscp     (import :telescope.builtin))
(local lsp-diag  (import :vim.lsp.diagnostic))
(local lsp-buf   (import :vim.lsp.buf))
(local dap       (import :dap))
(local dapui     (import :dapui))

;; General Telescope stuff
(map :<leader>ff skr-tlscp.files)
(map :<leader>fg tlscp.live_grep)
(map "<leader>/" skr-tlscp.search_buf)
(map :<leader>fs skr-tlscp.grep_string)
(map :<leader>fl skr-tlscp.lsp_workspace_symbols)

;; LSP
(map :dn         lsp-diag.goto_next)
(map :dp         lsp-diag.goto_prev)
(map :K          lsp-buf.hover)
(map :<leader>la skr-tlscp.lsp_code_actions)
(map :gd         skr-tlscp.lsp_def)
(map :gr         skr-tlscp.lsp_ref)
(map :gi         skr-tlscp.lsp_impl)
(map :<leader>ld skr-tlscp.lsp_ws_diagnostics)
(map :<leader>ls skr-tlscp.lsp_doc_symbols)

;; DAP
(map :<leader>db dap.toggle_breakpoint)
(map :<leader>dc dap.continue)
(map :<leader>ds dap.step_over)
(map :<leader>du dapui.toggle)

