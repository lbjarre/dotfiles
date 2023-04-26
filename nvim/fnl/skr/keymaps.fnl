(local diag (require :vim.diagnostic))
(local lsp-buf (require :vim.lsp.buf))
(local dap (require :dap))
(local dapui (require :dapui))
(local neotree/cmd (require :neo-tree.command))
(local ssr (require :ssr))
(local noice-lsp (require :noice.lsp))

(fn hard-reload []
  (local {: reload_module} (require :plenary.reload))
  (do
    (reload_module :skr)
    (require :skr)))

(fn setup []
  (fn map [mode key cmd]
    (vim.keymap.set mode key cmd {:remap false :silent true}))

  ;; Generic keymaps
  (map :n :<leader>cn :<cmd>cnext<cr>)
  (map :n :<leader>r hard-reload)
  ;; Clipboard yank/pasting
  (map [:n :v] :<leader>y "\"*y")
  (map :n :<leader>p "\"*p")
  (map :n :<leader>P "\"*P")
  ;; LSP
  (map :n :dn diag.goto_next)
  (map :n :dp diag.goto_prev)
  (map :n :K noice-lsp.hover)
  (map :n :<leader>la lsp-buf.code_action)
  (map :n :gt lsp-buf.type_definition)
  (map :n :<leader>lr lsp-buf.rename)
  ;; DAP
  (map :n :<leader>db dap.toggle_breakpoint)
  (map :n :<leader>dc dap.continue)
  (map :n :<leader>ds dap.step_over)
  (map :n :<leader>du dapui.toggle)
  ;; SSR
  (map [:n :x] :<leader>sr #(ssr.open))
  ;; Octo
  (map :n :<leader>gh "<cmd>Octo actions<cr>"))

(setup)

{: setup}
