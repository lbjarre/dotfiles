
-- Bootstrap packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- hotpot, for fennel goodness
  use {
    'rktjmp/hotpot.nvim',
    config = function() require("hotpot") end
  }

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function() require('skr.lsp').setup() end,
  }
  use 'nvim-lua/lsp_extensions.nvim'
  use 'folke/trouble.nvim'

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
    end
  }
  use 'L3MON4D3/LuaSnip'

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'windwp/nvim-ts-autotag',
      'nvim-treesitter/playground',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        autotag = { enable = true },
        playground = { enable = true },
      }
    end,
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
  use 'simrat39/symbols-outline.nvim' -- TODO: configure
  use {
    'kyazdani42/nvim-web-devicons',
    config = function() require('nvim-web-devicons').setup {} end,
  }

  -- Integrations with external services
  use {
    'pwntester/octo.nvim',
    config = function() require('octo').setup() end,
  }

  -- Other stuff
  use 'folke/which-key.nvim'
  use 'rhysd/git-messenger.vim'
  use 'mhinz/vim-startify'
  use 'machakann/vim-highlightedyank'
  use 'justinmk/vim-dirvish'

  -- Church of Tpope
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'

  -- Lang specific plugins
  use { 'cespare/vim-toml', branch = "main" }
  use 'b4b4r07/vim-hcl'
end)
