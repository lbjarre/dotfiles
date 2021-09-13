-- P is a print-inspect helper, prints the expanded table and returns the
-- argument back to the caller.
function P(x)
  print(vim.inspect(x))
  return x
end

function R(name)
  require('plenary.reload').reload_module(name)
  return require(name)
end

-- plugins
R('skr.plugins')

-- keymaps
R('skr.keymaps')

R('cmp').setup {
  sources = {
      { name = 'buffer' },
      { name = 'path' },
      { name = 'nvim_lsp' },
  },
}

-- other required setup
require('skr.lsp').setup()
require('skr.telescope').setup()
require('nvim-treesitter.configs').setup {
  highlight = { enable = true },
}
-- require('skr.dap')
require('indent_guides').setup()
require('which-key').setup()
require('skr.color')

-- custom statusline
vim.o.statusline = [[%!luaeval("require('skr.statuslime').statusline()")]]

