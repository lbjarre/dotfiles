-- plugins
require('skr.plugins')

-- P is a print-inspect helper, prints the expanded table and returns the
-- argument back to the caller.
function P(x)
  print(vim.inspect(x))
  return x
end

-- R forcefully reloads a lua module.
function R(name)
  -- default to this init module if name is missing.
  if not name then name = 'skr' end

  require('plenary.reload').reload_module(name)
  return require(name)
end

-- plugins
R('hotpot')

-- various options
local opt = vim.opt

-- looks
opt.background = 'dark'
opt.termguicolors = true
vim.cmd [[ colorscheme skr ]]
opt.colorcolumn = { 80, 100 }

-- startify
-- todo: how difficult can it be to rewrite this myself?
vim.g.startify_lists = {
  { type = "dir", header = { '  MRU ' .. vim.fn.getcwd() } },
}
vim.g.startify_change_to_dir = 0

-- whitespace chars
opt.showbreak = '↪'
opt.listchars = {
  tab = '→ ',
  eol = '↲',
  nbsp = '␣',
  trail = '•',
  extends = '⟩',
  precedes = '⟨',
}
opt.list = true

-- idk these are just copy pasted over
opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.hidden = true
opt.showcmd = true
opt.autoindent = true
opt.startofline = false

-- default tab setup
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

-- allow mouse usage, even though it brings shame to my family name
opt.mouse = 'a'

-- left column
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'

-- sensible splits
opt.splitright = true
opt.splitbelow = true

-- timeouts for sequences
opt.timeoutlen = 500
opt.ttimeoutlen = 10

-- visual stuff: don't show the mode in the command line since I have it in the statusline
opt.showmode = false

-- autocomplete options, don't allow for willy nilly inserts without me telling it to
opt.completeopt = 'menu,menuone,noinsert'

-- custom statusline
opt.statusline = [[%!luaeval("R('skr.statuslime').statusline()")]]

-- keymaps
R('skr.keymaps')

-- other required setup
-- TODO: I have tried to add all this to packer options like config, but does
--       not work? Need to understand what packer is doing I guess.
R('cmp').setup {
  snippet = {
    expand = function(args)
      R('luasnip').lsp_expand(args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'luasnip' },
  },
}
R('skr.lsp').setup()
R('skr.telescope').setup()
R('skr.dap')
-- R('skr.snippets').setup()
-- R('indent_guides').setup()
R('which-key').setup()
-- R('skr.color')

R('nvim-treesitter.configs').setup {
  highlight = { enable = true },
  autotag = { enable = true },
}

R('nvim-ts-autotag').setup()

