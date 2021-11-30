local lspconfig = require('lspconfig')
local ext_diagnostic = require('lsp_extensions.workspace.diagnostic')
local ext_inlay_hints = require('lsp_extensions.inlay_hints')
local lspstatus = require('lsp-status')

local servers = {
  'rust_analyzer',
  'gopls',
  'hls',
  'pylsp',
  'tsserver',
  'graphql',
  'terraformls',
  'cssls',
}

local ft_autofmt = {
  'go',
  'rust',
  'haskell',
  'typescript',
  'typescripsreact',
}

-- Custom on_attach function
local on_attach = function(client)
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  -- Enable inlay hints for rust, thanks TJ!
  if filetype == 'rust' then
      vim.cmd [[ autocmd BufEnter,BufWritePost <buffer> :lua require('skr.lsp').inlay_hints() ]]
  end

  -- Enable autoformatting on some langs
  if vim.tbl_contains(ft_autofmt, filetype) then
      vim.cmd [[autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()]]
  end

  lspstatus.on_attach(client)
end

local M = {}

M.setup = function()
  lspstatus.register_progress()

  -- Setup and attach all servers
  for _, server in ipairs(servers) do
    lspconfig[server].setup { 
      on_attach = on_attach,
      handlers = {
        ['textDocument/publishDiagnostics'] = vim.lsp.with(ext_diagnostic.handler, { signs = { severity_limit = 'Error' } }),
      },
    }
  end
end

M.inlay_hints = function()
  ext_inlay_hints.request {
    aligned = true,
    prefix = ' » ',
  }
end

local popup = require('plenary.popup')

M.rename = function()
  local win = popup.create('', {
    title = 'Rename',
    minwidth = 40,
    padding = {},
    border = true,
    should_enter = true,
    relative = 'cursor',
  })
  local buf = vim.api.nvim_win_get_buf(win)
  vim.api.nvim_buf_set_keymap(buf, 'i', '<cr>', '<esc>:q<cr>', { noremap = true, silent = true })
end

return M
