local lush = require('lush')
local hsl = lush.hsl

local bg_dark = hsl(210, 0, 15)
local grey = hsl(210, 0, 30)
local white = hsl(210, 0, 70)

local main = hsl(210, 50, 60)
local accent = main.rotate(-60).darken(50)

local red = hsl(360, 70, 20)
local yellow = main.rotate(190).darken(25)

return lush(function()
  return {
    -- Main text elements
    Normal     { fg = white },
    Comment    { fg = grey, gui = "italic" }, 
    Statement  { fg = main, gui = "italic" },
    Constant   { fg = accent },
    Special    { fg = grey.lighten(20) },
    Identifier { fg = white.saturate(40) },
    SignColumn { Normal, bg = bg_dark },
    Whitespace { fg = white },
    Type       { fg = accent, gui = "bold" },
    PreProc    { fg = main.darken(30) },
    Title      { fg = main, gui = "bold" },
    Directory  { Title, gui = "" },

    -- Backgrounds
    ColorColumn { Normal, bg = bg_dark },
    Pmenu       { Normal, bg = grey.darken(20) },
    Visual      { Normal, bg = grey.darken(20) },

    -- Others
    LineNr       { fg = grey },
    CursorLineNr { fg = grey.lighten(40) },
    Search       { bg = grey.saturate(10) },
    WildMenu     { Search },
    NonText      { LineNr },
    ErrorMsg     { bg = red },

    -- Statusline
    StatusLine            { Normal, bg = grey.darken(40) },
    StatusLineAlt         { Normal, bg = grey },
    StatusLineModeNormal  { StatusLineAlt },
    StatusLineModeInsert  { Normal, bg = main.darken(60) },
    StatusLineModeVisual  { Normal, bg = yellow },
    StatusLineModeReplace { Normal, bg = red },
  }
end)
