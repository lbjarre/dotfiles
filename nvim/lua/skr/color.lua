local lush = require('lush')
local hsl = lush.hsl

local bw = {
  dark = hsl(210, 0, 15),
  grey = hsl(210, 0, 30),
  lightgrey = hsl(210, 0, 45),
  light = hsl(210, 0, 65),
  bright = hsl(210, 0, 75),
}

local blue = {
  light = hsl(210, 20, 50),
  mid = hsl(210, 20, 35),
  dark = hsl(210, 20, 20),
}

local green = {
  light = hsl(150, 35, 40),
  mid = hsl(150, 35, 30),
  dark = hsl(150, 35, 20),
}

local red = {
  light = hsl(360, 45, 60),
  mid = hsl(360, 45, 35),
  dark = hsl(360, 45, 20),
}

local yellow = {
  light = hsl(40, 45, 50),
  mid = hsl(40, 45, 40),
  dark = hsl(40, 45, 30),
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
    Operator   { fg = bw.bright, gui = bold },
    Constant   { fg = accent.mid },
    String     { Constant },
    Special    { fg = bw.lightgrey },
    Identifier { fg = bw.light },
    SignColumn { Normal, bg = bw.dark },
    Type       { fg = bw.bright, gui = bold },
    PreProc    { Statement },
    Title      { fg = main.light, gui = bold },
    Directory  { Title, gui = '' },
    SpecialKey { fg = main.light.lighten(40) },
    MatchParen { bg = main.dark },

    -- Treesitter elements
    TSFuncBuiltin { fg = bw.bright, gui = italic },

    -- Diagnostics
    DiagnosticError { fg = red.mid },
    DiagnosticWarn  { fg = yellow.mid },

    -- Backgrounds
    ColorColumn  { Normal, bg = bw.dark },
    Pmenu        { Normal, bg = bw.grey.darken(20) },
    PmenuSel     { Pmenu,  bg = bw.light, fg = bw.dark },
    Visual       { gui = reverse },
    VertSplit    { bg = bw.dark, fg = bw.grey },
    WinSeparator { bg = bw.dark, fg = bw.grey },

    -- Diffs
    DiffAdd    { bg = green.dark,  fg = bw.bright },
    DiffChange { bg = yellow.dark, fg = bw.bright },
    DiffDelete { bg = red.dark,    fg = bw.bright },
    DiffText   { bg = bw.grey,     fg = bw.bright },
    GitSignsAdd    { SignColumn, fg = DiffAdd.bg },
    GitSignsChange { SignColumn, fg = DiffChange.bg },
    GitSignsDelete { SignColumn, fg = DiffDelete.bg },

    -- Others
    LineNr       { fg = bw.grey },
    CursorLineNr { fg = bw.grey.lighten(20) },
    Search       { bg = bw.grey.saturate(10) },
    WildMenu     { Search },
    NonText      { LineNr, fg = LineNr.fg.darken(20) },
    Whitespace   { LineNr, fg = LineNr.fg.darken(20) },
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
