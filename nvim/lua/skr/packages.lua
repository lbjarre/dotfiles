local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	-- Tangerine, used for fennel -> lua transpilation.
	{
		'udayvir-singh/tangerine.nvim',
		-- Bump up the priority here, since we need this in order to require most
		-- of my personal config.
		priority = 1,
		init = function()
			require('tangerine').setup({
				target = vim.fn.stdpath('data') .. '/tangerine',
				compiler = {
					verbose = false,
					hooks = { 'onsave', 'oninit' },
				},
			})
		end,
	},

	-- LSP
	-- lspconfig contains most of the common setups for most standard LSP servers.
	{
		'neovim/nvim-lspconfig',
		config = function()
			require('skr.lsp').setup()
		end,
	},
	-- Deprecated package for some extensions: I use this for inlay hints atm,
	-- but I should move away from using this package.
	{ 'nvim-lua/lsp_extensions.nvim' },
	-- null-ls wraps regular lua functions and/or other commands that don't speak
	-- LSP into a LSP-client for nvim.
	{ 'jose-elias-alvarez/null-ls.nvim' },
	-- Quickfix list like viewer for LSP diagnostics.
	{ 'folke/trouble.nvim' },
	-- An LSP aware widget for the statusline, showing which class/func/etc the
	-- cursor is currently on.
	{
		'SmiteshP/nvim-navic',
		dependencies = { 'neovim/nvim-lspconfig' },
	},

	-- Wrapper around builtin terminal for easy toggling.
	{ 'akinsho/toggleterm.nvim' },

	-- Completion & snippets
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/vim-vsnip',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-nvim-lsp',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			local cmp = require('cmp')
			cmp.setup({
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
				}),
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
					{ name = 'path' },
					{ name = 'luasnip' },
				},
			})
		end,
	},
	{ 'L3MON4D3/LuaSnip' },

	-- Treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		dependencies = {
			'windwp/nvim-ts-autotag',
			'nvim-treesitter/playground',
			'nvim-treesitter/nvim-treesitter-textobjects',
			'JoosepAlviste/nvim-ts-context-commentstring',
		},
		config = function()
			require('nvim-treesitter.configs').setup({
				autotag = { enable = true },
				playground = { enable = true },
				indent = { enable = true },
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { 'org' },
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							['af'] = '@function.outer',
							['if'] = '@function.inner',
						},
					},
				},
			})
		end,
	},

	-- SSR: Structural search & replace. Pretty cool thing to search/replace with
	-- tree-sitter queries. Not entirely sure how useful it is though lol.
	{
		'cshuaimin/ssr.nvim',
		config = function()
			require('ssr').setup()
		end,
	},

	-- Debugging
	{
		'mfussenegger/nvim-dap',
		config = function()
			require('skr.dap')
		end,
	},
	{ 'rcarriga/nvim-dap-ui' },

	-- Telescope
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
		config = function()
			require('skr.telescope').setup()
		end,
	},
	{ 'nvim-telescope/telescope-fzy-native.nvim' },

	-- Look & feel

	-- Lush is a nice interactive colorscheme package.
	{ 'rktjmp/lush.nvim' },
	-- Nicer nerdfont icons.
	{
		'kyazdani42/nvim-web-devicons',
		config = function()
			require('nvim-web-devicons').setup({})
		end,
	},
	-- Fancier UI elements, like select and input boxes.
	{
		'stevearc/dressing.nvim',
		config = function()
			local dressing = require('dressing')
			dressing.setup()
			dressing.patch()
		end,
	},
	-- Progress indicator for longer-running tasks.
	{
		'j-hui/fidget.nvim',
		init = function()
			require('fidget').setup()
		end,
	},
	-- ZenMode, nice for decluttering or showing specific codeblocks
	{
		'Pocco81/true-zen.nvim',
		config = function()
			require('true-zen').setup()
		end,
	},

	-- Commenting lines.
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end,
	},

	-- Lots of good integrations with git, like showing diffs in the numberline
	-- and being able to see blames inline etc
	{
		'lewis6991/gitsigns.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('gitsigns').setup()
		end,
	},

	-- UI for viewing various git diffs.
	{
		'sindrets/diffview.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('diffview').setup()
		end,
	},

	-- Github integrations
	{
		'pwntester/octo.nvim',
		config = function()
			require('octo').setup()
		end,
	},

	-- Plugin for displaying tree structures, including a file browser.
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v2.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'kyazdani42/nvim-web-devicons', -- not strictly required, but recommended
			'MunifTanjim/nui.nvim',
		},
	},

	-- Hydra, easy submodes
	{ 'anuvyklack/hydra.nvim' },

	-- Note taking plugin.
	-- Honestly I don't really use this one, probably should reevaluate it...
	{ 'renerocksai/telekasten.nvim' },
	{
		'nvim-neorg/neorg',
		build = ':Neorg sync-parsers',
		opts = {
			load = {
				['core.defaults'] = {}, -- Loads default behaviour
				['core.norg.concealer'] = {}, -- Adds pretty icons to your documents
				['core.norg.dirman'] = { -- Manages Neorg workspaces
					config = {
						default_workspace = 'notes',
						workspaces = {
							notes = '~/notes/neorg',
						},
					},
				},
				['core.norg.completion'] = { -- Setup completions via nvim-cmp
					config = { engine = 'nvim-cmp' },
				},
			},
		},
		dependencies = { { 'nvim-lua/plenary.nvim' } },
	},

	-- Other stuff
	{ 'folke/which-key.nvim' }, -- UI for showing keybinds
	{ 'rhysd/git-messenger.vim' }, -- Git integrations
	{ 'mhinz/vim-startify' }, -- Start screen
	{ 'jbyuki/venn.nvim' }, -- ASCII box diagram drawing
	{
		'iamcco/markdown-preview.nvim',
		build = 'cd app && npm install',
		setup = function()
			vim.g.mkdp_filetypes = { 'markdown' }
		end,
		ft = { 'markdown' },
	},

	-- Church of Tpope
	{ 'tpope/vim-surround' },

	-- Lang specific plugins
	{ 'cespare/vim-toml',               branch = 'main' },
	{ 'b4b4r07/vim-hcl' },
	{ 'towolf/vim-helm' },

	-- Just for fun stuff

	-- Plugin for running cellular automata based on buffer content
	{ 'eandrju/cellular-automaton.nvim' },
}, {})
