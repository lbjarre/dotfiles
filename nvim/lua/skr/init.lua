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
require('hotpot')

-- various options

-- whitespace chars
vim.o.showbreak = "↪"
vim.o.listchars = "tab:  ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨"
-- Good alternative setting for tab listchar: "tab:→\ "
-- I think it adds a bit too much noise in tab-indented languages though

-- idk these are just copy pasted over
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false

vim.o.hidden = true
vim.o.showcmd = true
vim.o.autoindent = true
vim.o.startofline = false

-- allow mouse usage, even though it brings shame to my family name
vim.o.mouse = 'a'

-- left column
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'

-- sensible splits
vim.o.splitright = true
vim.o.splitbelow = true

-- timeouts for sequences
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10

-- visual stuff: don't show the mode in the command line since I have it in the statusline
vim.o.showmode = false

-- autocomplete options, don't allow for willy nilly inserts without me telling it to
vim.o.completeopt = 'menu,menuone,noinsert'

-- custom statusline
vim.o.statusline = [[%!luaeval("require('skr.statuslime').statusline()")]]

-- keymaps
require('skr.keymaps')
require('skr.keymaps_fnl')

-- other required setup
-- TODO: I have tried to add all this to packer options like config, but does
--       not work? Need to understand what packer is doing I guess.
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
  highlight = { enable = true },
  autotag = { enable = true },
}

require('nvim-ts-autotag').setup()

