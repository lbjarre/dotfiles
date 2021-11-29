local lush = require('lush')
local hsl = lush.hsl

local bg_dark = hsl(210, 0, 15)
local grey = hsl(210, 0, 30)
local white = hsl(210, 0, 70)

local main = hsl(210, 50, 60)
local accent = main.rotate(-60).darken(30)

local red = hsl(360, 70, 20)
local yellow = main.rotate(190).darken(25)

return lush(function()
  return {
    -- Main text elements
    Normal     { fg = white },
    Comment    { fg = grey.lighten(15), gui = "italic" }, 
    Statement  { fg = main, gui = "italic" },
    Operator   { fg = main },
    Constant   { fg = accent },
    Special    { fg = grey.lighten(20) },
    Identifier { fg = white },
    SignColumn { Normal, bg = bg_dark },
    Type       { fg = accent, gui = "bold" },
    PreProc    { fg = main.darken(30) },
    Title      { fg = main, gui = "bold" },
    Directory  { Title, gui = "" },

    -- Backgrounds
    ColorColumn { Normal, bg = bg_dark },
    Pmenu       { Normal, bg = grey.darken(20) },
    PmenuSel    { Pmenu,  bg = Pmenu.bg.lighten(40), fg = Pmenu.fg.darken(70) },
    Visual      { Normal, bg = grey.darken(20) },

    -- Others
    LineNr       { fg = grey },
    CursorLineNr { fg = grey.lighten(20) },
    Search       { bg = grey.saturate(10) },
    WildMenu     { Search },
    NonText      { LineNr, fg = LineNr.fg.darken(30) },
    Whitespace   { LineNr, fg = LineNr.fg.darken(30) },
    Error        { bg = red },
    ErrorMsg     { Error },
    Todo         { bg = yellow, fg = Normal.fg.lighten(50) },

    -- Statusline
    StatusLine            { Normal, bg = grey.darken(40) },
    StatusLineAlt         { Normal, bg = grey },
    StatusLineModeNormal  { StatusLineAlt },
    StatusLineModeInsert  { Normal, bg = main.darken(60) },
    StatusLineModeVisual  { Normal, bg = yellow, fg = Normal.fg.lighten(50) },
    StatusLineModeReplace { Normal, bg = red },
  }
end)
