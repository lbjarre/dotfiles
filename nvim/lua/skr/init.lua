-- Plugins
require('skr.packages')
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
