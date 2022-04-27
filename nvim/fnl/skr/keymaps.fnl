(local skr-tlscp (require :skr.telescope))
(local tlscp     (require :telescope.builtin))
(local lsp-diag  (require :vim.lsp.diagnostic))
(local lsp-buf   (require :vim.lsp.buf))
(local dap       (require :dap))
(local dapui     (require :dapui))

(fn nmap [key cmd]
  (vim.keymap.set :n key cmd {:remap false :silent true}))

(fn vmap [key cmd]
  (vim.keymap.set :v key cmd {:remap false :silent true}))

;; Generic keymaps
(nmap :<leader>cn "<cmd>cnext<cr>")

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
(nmap :gt         lsp-buf.type_definition)
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

