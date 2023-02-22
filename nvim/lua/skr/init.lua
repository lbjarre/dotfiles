-- Plugins
require('skr.packages')

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
R('skr.options').setup()

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
R('skr.dap')

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
