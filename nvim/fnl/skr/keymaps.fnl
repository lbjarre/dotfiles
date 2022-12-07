(local skr-tlscp   (require :skr.telescope))
(local tlscp       (require :telescope.builtin))
(local diag        (require :vim.diagnostic))
(local lsp-buf     (require :vim.lsp.buf))
(local dap         (require :dap))
(local dapui       (require :dapui))
(local neotree/cmd (require :neo-tree.command))

(fn setup []
  (fn map [mode key cmd]
    (vim.keymap.set mode key cmd {:remap false :silent true}))

  ;; Generic keymaps
  (map :n :<leader>cn "<cmd>cnext<cr>")
  (map :n :<leader>r  R)

  ;; Clipboard yank/pasting
  (map [:n :v] :<leader>y "\"*y")
  (map :n      :<leader>p "\"*p")
  (map :n      :<leader>P "\"*P")

  (map :n :<leader>t #(neotree/cmd.execute {:toggle true}))

  ;; Telescope
  (map :n :<leader>ff skr-tlscp.files)
  (map :n :<leader>fg tlscp.live_grep)
  (map :n :<leader>/  skr-tlscp.search-buf)
  (map :n :<leader>fs skr-tlscp.grep-string)
  (map :n :<leader>fl skr-tlscp.lsp-workspace-symbols)
  (map :n :<leader>fn skr-tlscp.files-nv)

  ;; LSP
  (map :n :dn         diag.goto_next)
  (map :n :dp         diag.goto_prev)
  (map :n :K          lsp-buf.hover)
  (map :n :<leader>la lsp-buf.code_action)
  (map :n :gd         skr-tlscp.lsp-def)
  (map :n :gt         lsp-buf.type_definition)
  (map :n :gr         skr-tlscp.lsp-ref)
  (map :n :gi         skr-tlscp.lsp-impl)
  (map :n :<leader>ld skr-tlscp.diagnostics)
  (map :n :<leader>ls skr-tlscp.lsp-doc-symbols)
  (map :n :<leader>lr lsp-buf.rename)

  ;; DAP
  (map :n :<leader>db dap.toggle_breakpoint)
  (map :n :<leader>dc dap.continue)
  (map :n :<leader>ds dap.step_over)
  (map :n :<leader>du dapui.toggle))

(setup)

{: setup}
