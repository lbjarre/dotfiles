local lspconfig = require('lspconfig')
local completion = require('completion')

local M = {}

-- Custom on_attach function
local on_attach = function(client)
    completion.on_attach(client) -- LSP based completions
    local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

    -- Enable inlay hints for rust, thanks TJ!
    if filetype == 'rust' then
        vim.cmd(
            [[autocmd BufEnter,BufWritePost <buffer> :lua require('lsp_extensions.inlay_hints').request { ]]
              .. [[aligned = true, prefix = " » " ]]
            .. [[} ]]
        )
    end

    -- Enable autoformatting on some langs
    if vim.tbl_contains({'go', 'rust', 'haskell'}, filetype) then
        vim.cmd [[autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()]]
    end
end

M.setup = function()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    require('lsp_extensions.workspace.diagnostic').handler, {
      signs = { severity_limit = "Error" },
    }
  )

  -- Setup and attach all servers
  local lsp_servers = {
    'rust_analyzer',
    'gopls',
    'hls',
    'pylsp',
    'tsserver',
    'graphql',
  }
  for _, server in ipairs(lsp_servers) do
    lspconfig[server].setup { on_attach = on_attach }
  end
end

return M
