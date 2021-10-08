local nmap = function(key)
  vim.api.nvim_set_keymap('n', key[1], key[2], { noremap = true, silent = true })
end

-- Telescope
nmap { '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>" }
nmap { '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>" }
nmap { '<leader>/',  "<cmd>lua require('skr.telescope').search_buf()<cr>" }
nmap { '<leader>fs', "<cmd>lua require('skr.telescope').grep_string()<CR>" }
nmap { '<leader>fl', "<cmd>lua require('skr.telescope').lsp_workspace_symbols()<cr>" }

-- LSP
nmap { 'dn',         "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>" }
nmap { 'dp',         "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>" }
nmap { 'K',          "<cmd>lua vim.lsp.buf.hover()<cr>" }
nmap { '<leader>la', "<cmd>lua require('skr.telescope').lsp_code_actions()<cr>" }
nmap { 'gd',         "<cmd>lua require('skr.telescope').lsp_def()<cr>" }
nmap { 'gr',         "<cmd>lua require('skr.telescope').lsp_ref()<cr>" }
nmap { 'gi',         "<cmd>lua require('skr.telescope').lsp_impl()<cr>"}
nmap { '<leader>ld', "<cmd>lua require('skr.telescope').lsp_ws_diagnostics()<cr>" }
nmap { '<leader>ls', "<cmd>lua require('skr.telescope').lsp_doc_symbols()<cr>" }

-- DAP

nmap { '<leader>db', "<cmd>lua require('dap').toggle_breakpoint()<cr>"}
nmap { '<leader>dc', "<cmd>lua require('dap').continue()<cr>"}
nmap { '<leader>ds', "<cmd>lua require('dap').step_over()<cr>"}
nmap { '<leader>du', "<cmd>lua require('dapui').toggle()<cr>"}
