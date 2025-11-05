local function bootstrap(name, url)
	local path = vim.fn.stdpath('data') .. '/lazy/' .. name

	-- Check if we need to manually clone the repo
	if vim.fn.isdirectory(path) == 0 then
		vim.fn.system({
			'git',
			'clone',
			'--filter=blob:none',
			'--single-branch',
			url,
			path,
		})
	end

	-- Add the repo to the rtp
	vim.opt.rtp:prepend(path)
end

bootstrap('lazy.nvim', 'https://github.com/folke/lazy.nvim.git')
bootstrap('tangerine.nvim', 'https://github.com/udayvir-singh/tangerine.nvim.git')

require('tangerine').setup({
	target = vim.fn.stdpath('data') .. '/tangerine',
	rtpdirs = {
		'ftplugin',
		'plugin',
		'lsp',
	},
	compiler = {
		verbose = false,
		hooks = { 'onsave', 'oninit' },
	},
})

-- Options
require('skr.options').setup()
-- Plugins
local pkgs = require('skr.pkg')
require('lazy').setup(pkgs)
-- Keymaps
-- TODO(lb): probably should just set these in their appropriate package setup
require('skr.keymaps')
vim.cmd([[ colorscheme skr ]])
