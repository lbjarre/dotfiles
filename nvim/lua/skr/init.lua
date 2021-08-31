-- plugins
require('skr.plugins')

-- keymaps
require('skr.keymaps')

-- other required setup
require('skr.lsp').setup()
require('skr.telescope').setup()
require('nvim-treesitter.configs').setup {
  highlight = { enable = true },
}
require('indent_guides').setup()
require('which-key').setup()

-- custom statusline
vim.o.statusline = [[%!luaeval("require('skr.statuslime').statusline()")]]

-- P is a print-inspect helper, prints the expanded table and returns the
-- argument back to the caller.
function P(x)
  print(vim.inspect(x))
  return x
end
