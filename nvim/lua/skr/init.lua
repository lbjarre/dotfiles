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
	compiler = {
		verbose = false,
		hooks = { 'onsave', 'oninit' },
	},
})

-- Plugins
local pkgs = require('skr.pkg')
require('lazy').setup(pkgs)
-- Options
require('skr.options').setup()

-- P is a print-inspect helper, prints the expanded table and returns the
-- argument back to the caller.
function P(x)
	print(vim.inspect(x))
	return x
end

-- R forcefully reloads a lua module.
function R(name)
	-- default to this init module if name is missing.
	if not name then
		name = 'skr'
	end

	require('plenary.reload').reload_module(name)
	return require(name)
end
