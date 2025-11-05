vim.o.background = 'dark'
vim.g.colors_name = 'skr'

package.loaded['skr.color'] = nil

local lush = require('lush')
local skr = require('skr.color')
lush(skr)
