(local skr-tlscp (require :skr.telescope-fnl))
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
(nmap :<leader>r  R)

;; Clipboard yank/pasting
(nmap :<leader>y "\"*y")
(vmap :<leader>y "\"*y")
(nmap :<leader>p "\"*p")
(nmap :<leader>P "\"*P")

;; Telescope
(nmap :<leader>ff skr-tlscp.files)
(nmap :<leader>fg tlscp.live_grep)
(nmap :<leader>/  skr-tlscp.search-buf)
(nmap :<leader>fs skr-tlscp.grep-string)
(nmap :<leader>fl skr-tlscp.lsp-workspace-symbols)
(nmap :<leader>fn skr-tlscp.files-nv)

;; LSP
(nmap :dn         lsp-diag.goto_next)
(nmap :dp         lsp-diag.goto_prev)
(nmap :K          lsp-buf.hover)
(nmap :<leader>la lsp-buf.code_action)
(nmap :gd         skr-tlscp.lsp-def)
(nmap :gt         lsp-buf.type_definition)
(nmap :gr         skr-tlscp.lsp-ref)
(nmap :gi         skr-tlscp.lsp-impl)
(nmap :<leader>ld skr-tlscp.diagnostics)
(nmap :<leader>ls skr-tlscp.lsp-doc-symbols)
(nmap :<leader>lr lsp-buf.rename)

;; DAP
(nmap :<leader>db dap.toggle_breakpoint)
(nmap :<leader>dc dap.continue)
(nmap :<leader>ds dap.step_over)
(nmap :<leader>du dapui.toggle)

