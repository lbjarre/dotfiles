
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
  use 'nvim-lua/completion-nvim'

  -- Completion & snippets
  use 'hrsh7th/nvim-cmp' -- TODO: configure

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }

  -- Debugging
  use 'mfussenegger/nvim-dap' -- TODO: configure

  -- Telescope
  use {
      'nvim-telescope/telescope.nvim',
      requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
      config = function() require('skr.telescope').setup() end,
  }
  use 'nvim-telescope/telescope-fzy-native.nvim'

  -- Look & feel
  use 'rktjmp/lush.nvim' -- TODO: configure
  use 'simrat39/symbols-outline.nvim' -- TODO: configure

  -- Other stuff
  use 'glepnir/indent-guides.nvim'
  use 'folke/which-key.nvim'
  use 'rhysd/git-messenger.vim'
  use 'mhinz/vim-startify'
  use 'machakann/vim-highlightedyank'
  use 'justinmk/vim-dirvish'

  -- Church of Tpope
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'

  -- Lang specific plugins
  use 'cespare/vim-toml'
  use 'b4b4r07/vim-hcl'
end)
