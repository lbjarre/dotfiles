local lspconfig = require('lspconfig')
local ext_diagnostic = require('lsp_extensions.workspace.diagnostic')
local ext_inlay_hints = require('lsp_extensions.inlay_hints')

local servers = {
  'rust_analyzer',
  'gopls',
  'hls',
  'pylsp',
  'sumneko_lua',
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
  'terraform',
  'hcl',
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
end

local M = {}

M.setup = function()
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

return M
