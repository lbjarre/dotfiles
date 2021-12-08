local lush = require('lush')
local hsl = lush.hsl

local bw = {
  dark = hsl(210, 0, 15),
  grey = hsl(210, 0, 30),
  lightgrey = hsl(210, 0, 45),
  light = hsl(210, 0, 70),
  bright = hsl(210, 0, 85),
}

local blue = {
  light = hsl(210, 50, 60),
  mid = hsl(210, 50, 35),
  dark = hsl(210, 50, 20),
}

local green = {
  light = hsl(150, 50, 50),
  mid = hsl(150, 50, 35),
  dark = hsl(150, 50, 15),
}

local red = {
  light = hsl(360, 55, 60),
  mid = hsl(360, 55, 35),
  dark = hsl(360, 55, 20),
}

local yellow = {
  light = hsl(40, 50, 50),
  mid = hsl(40, 50, 45),
  dark = hsl(40, 50, 35),
}

local main = blue
local accent = green

local italic = 'italic'
local bold = 'bold'
local reverse = 'reverse'

return lush(function()
  return {
    -- Main text elements
    Normal     { fg = bw.light },
    Comment    { fg = bw.lightgrey, gui = italic }, 
    Statement  { fg = main.light, gui = italic },
    Operator   { fg = main.light },
    Constant   { fg = accent.mid },
    String     { Constant },
    Special    { fg = bw.lightgrey },
    Identifier { fg = bw.light },
    SignColumn { Normal, bg = bw.dark },
    Type       { Constant, gui = bold },
    PreProc    { fg = main.mid, gui = italic },
    Title      { fg = main.light, gui = bold },
    Directory  { Title, gui = '' },
    SpecialKey { fg = main.light.lighten(40) },
    MatchParen { bg = main.dark },

    -- Treesitter elements
    TSFuncBuiltin { fg = main.mid, gui = italic },

    -- Diagnostics
    DiagnosticError { fg = red.mid },
    DiagnosticWarn  { fg = yellow.mid },

    -- Backgrounds
    ColorColumn { Normal, bg = bw.dark },
    Pmenu       { Normal, bg = bw.grey.darken(20) },
    PmenuSel    { Pmenu,  bg = bw.light, fg = bw.dark },
    Visual      { gui = reverse },
    VertSplit   { bg = bw.dark, fg = bw.grey },

    -- Diffs
    DiffAdd    { bg = green.mid,  fg = bw.bright },
    DiffChange { bg = yellow.mid, fg = bw.bright },
    DiffDelete { bg = red.mid,    fg = bw.bright },
    DiffText   { bg = bw.grey,    fg = bw.bright },

    -- Others
    LineNr       { fg = bw.grey },
    CursorLineNr { fg = bw.grey.lighten(20) },
    Search       { bg = bw.grey.saturate(10) },
    WildMenu     { Search },
    NonText      { LineNr, fg = LineNr.fg.darken(30) },
    Whitespace   { LineNr, fg = LineNr.fg.darken(30) },
    Error        { bg = red.dark },
    ErrorMsg     { Error },
    WarningMsg   { Error },
    Todo         { bg = yellow.dark, fg = Normal.fg.lighten(50) },

    -- Statusline
    StatusLine            { Normal, bg = bw.grey.darken(40) },
    StatusLineNC          { fg = StatusLine.bg, bg = StatusLine.bg.darken(20) },
    StatusLineAlt         { Normal, bg = bw.grey, fg = bw.light },
    StatusLineModeNormal  { StatusLineAlt },
    StatusLineModeInsert  { Normal, bg = blue.dark, fg = bw.light },
    StatusLineModeVisual  { Normal, bg = yellow.dark, fg = bw.bright },
    StatusLineModeReplace { Normal, bg = red.dark, fg = bw.light },
  }
end)
