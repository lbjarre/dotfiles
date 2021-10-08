local lush = require('lush')
local hsl = lush.hsl

local bg_dark = hsl(0, 0, 20)

return lush(function()
  return {
    ColorColumn { bg = bg_dark.lighten(20) },
  }
end)
