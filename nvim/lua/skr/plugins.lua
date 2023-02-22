-- Bootstrap packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

return require('packer').startup(function(use)
	use 'udayvir-singh/tangerine.nvim'
  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function() require('skr.lsp').setup() end,
  }
  use 'nvim-lua/lsp_extensions.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'
  -- use 'nvim-lua/lsp-status.nvim'
  use 'folke/trouble.nvim'
  use {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup()
    end
  }

  -- Completion & snippets
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      require('cmp').setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        sources = {
          { name = 'buffer' },
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
      }
    end
  }
  use {
    'L3MON4D3/LuaSnip',
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'windwp/nvim-ts-autotag',
      'nvim-treesitter/playground',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
  }

  -- Debugging
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'

  -- Telescope
  use {
      'nvim-telescope/telescope.nvim',
      requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
      config = function() require('skr.telescope').setup() end,
  }
  use 'nvim-telescope/telescope-fzy-native.nvim'

  -- Look & feel
  use 'rktjmp/lush.nvim'
  use {
    'kyazdani42/nvim-web-devicons',
    config = function() require('nvim-web-devicons').setup {} end,
  }
  use {
    'stevearc/dressing.nvim',
    config = function()
      local dressing = require('dressing')
      dressing.setup()
      dressing.patch()
    end,
  }

  -- ZenMode, nice for decluttering or showing specific codeblocks
  use {
    'Pocco81/true-zen.nvim',
    config = function() require('true-zen').setup() end,
  }

  -- An LSP aware widget for the statusline, showing which class/func/etc the
  -- cursor is currently on.
  use {
    "SmiteshP/nvim-navic",
    requires = { "neovim/nvim-lspconfig" },
    --config = function() require('nvim-navic').setup() end,
  }

  -- Commenting lines.
  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end,
  }

  -- Lots of good integrations with git, like showing diffs in the numberline
  -- and being able to see blames inline etc
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }

  -- UI for viewing various git diffs.
  use {
    'sindrets/diffview.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('diffview').setup() end,
  }

  -- Github integrations
  use {
    'pwntester/octo.nvim',
    config = function() require('octo').setup() end,
  }

  -- Plugin for displaying tree structures, including a file browser.
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    }
  }

  -- Hydra, easy submodes
  use 'anuvyklack/hydra.nvim'

  -- Orgmode (trying it out a bit!)
  use 'nvim-orgmode/orgmode'

  -- Actually, orgmode might not be for me...
  use 'renerocksai/telekasten.nvim'

  -- Other stuff
  use 'folke/which-key.nvim' -- UI for showing keybinds
  use 'rhysd/git-messenger.vim' -- Git integrations
  use 'mhinz/vim-startify' -- Start screen
  use 'jbyuki/venn.nvim' -- ASCII box diagram drawing
  use({
    'iamcco/markdown-preview.nvim',
    run = 'cd app && npm install',
    setup = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  })

  -- Church of Tpope
  use 'tpope/vim-surround'

  -- Lang specific plugins
  use { 'cespare/vim-toml', branch = "main" }
  use 'b4b4r07/vim-hcl'
  use 'towolf/vim-helm'

  -- Just for fun stuff

  -- Plugin for running cellular automata based on buffer content
  use 'eandrju/cellular-automaton.nvim'
end)
