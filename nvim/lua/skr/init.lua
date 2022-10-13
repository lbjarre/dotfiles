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

-- Status lines 
-- Statusline eval from separate module (fnl/skr/statuslime.fnl)
opt.statusline = [[%!luaeval("R('skr.statuslime').statusline()")]]
opt.winbar     = "%f"
opt.laststatus = 3  -- Set global statusline for the entire screen


-- keymaps
R('skr.keymaps')

-- snippets
R('skr.fnlsnip').setup()

-- other required setup
-- TODO: I have tried to add all this to packer options like config, but does
--       not work? Need to understand what packer is doing I guess.
--R('luasnip').config.setup()
local cmp = R('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      R('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'orgmode' },
  }),
}
R('skr.lsp').setup()
R('skr.dap')
R('skr.toggleterm').setup()
-- R('skr.snippets').setup()
-- R('indent_guides').setup()
R('which-key').setup()
-- R('skr.color')
require('skr.hydra').setup()

require('nvim-ts-autotag').setup()

require('nvim-treesitter.configs').setup {
  autotag     = { enable = true },
  playground  = { enable = true },
  indent      = { enable = true },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'org'},
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
      },
    },
  },
}

local zkhome = vim.fn.expand("~/zk")
require('telekasten').setup({
  home      = zkhome,
  dailies   = zkhome .. '/' .. 'daily',
  weeklies  = zkhome .. '/' .. 'weekly',
  templates = zkhome .. '/' .. 'templates',
})

-- augroups
-- Autocmd for hightlight yanked text.
local au_yank = vim.api.nvim_create_augroup("Yank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
  group    = au_yank,
  callback = function() vim.highlight.on_yank() end,
})

