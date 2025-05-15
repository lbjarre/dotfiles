(local dap (require :dap))
(local dap-widgets (require :dap.ui.widgets))
(local dapui (require :dapui))
(local ssr (require :ssr))

(lambda map [mode key cmd ?desc]
  (vim.keymap.set mode key cmd {:remap false :silent true :desc ?desc}))

(fn setup []
  ;; Clipboard yank/pasting
  (map [:n :v] :<leader>y "\"*y" "Yank into clipboard")
  (map :n :<leader>p "\"*p" "Paste from clipboard")
  (map :n :<leader>P "\"*P" "Paste from clipboards")
  ;; LSP
  (map :n :grt vim.lsp.buf.type_definition :vim.lsp.buf.type_definition)
  ;; Toggle inlay hints
  (map :n :<leader>lh
       (fn []
         (let [enabled? (vim.lsp.inlay_hint.is_enabled)]
           (vim.lsp.inlay_hint.enable (not enabled?))))
       "[LSP] toggle inlay hints")
  ;; DAP
  (map :n :<leader>db dap.toggle_breakpoint "Toggle breakpoint")
  (map :n :<leader>dc dap.continue "Debug continue")
  (map :n :<leader>ds dap.step_over "Debug step-over")
  (map :n :<leader>dl dap.run_last "Debug run last")
  (map :n :<leader>du dapui.toggle "Debug UI toggle")
  (map [:n :v] :<leader>dh dap-widgets.hover "Debug hover local")
  (map [:n :v] :<leader>dp dap-widgets.preview "Debug preview local")
  ;; SSR
  (map [:n :x] :<leader>sr #(ssr.open))
  ;; Octo
  (map :n :<leader>gh "<cmd>Octo actions<cr>"))

(setup)

{: setup}
