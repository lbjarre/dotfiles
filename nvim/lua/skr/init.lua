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
require('skr.plugins')

-- keymaps
require('skr.keymaps')

-- other required setup
require('cmp').setup {
  snippet = {
    expand = function(args)
      R('luasnip').lsp_expand(args.body)
    end,
  },
  sources = {
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
require('skr.lsp').setup()
require('skr.telescope').setup()
require('skr.dap')
-- R('skr.snippets').setup()
-- R('indent_guides').setup()
R('which-key').setup()
-- R('skr.color')

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
}

-- custom statusline
vim.o.statusline = [[%!luaeval("require('skr.statuslime').statusline()")]]

