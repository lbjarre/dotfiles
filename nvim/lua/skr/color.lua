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
	light = hsl(210, 25, 55),
	mid = hsl(210, 25, 40),
	dark = hsl(210, 25, 25),
}

local green = {
	light = hsl(140, 15, 55),
	mid = hsl(140, 15, 40),
	dark = hsl(140, 15, 20),
}

local red = {
	light = hsl(360, 40, 60),
	mid = hsl(360, 40, 35),
	dark = hsl(360, 40, 25),
}

local yellow = {
	light = hsl(40, 40, 50),
	mid = hsl(40, 40, 35),
	dark = hsl(40, 40, 25),
}

local purple = {
	light = hsl(320, 15, 50),
	mid = hsl(320, 15, 45),
	dark = hsl(320, 15, 25),
}

local primary = blue
local secondary = green
local tertiary = purple

local italic = 'italic'
local bold = 'bold'
local reverse = 'reverse'

return lush(function(injected_symbols)
	local sym = injected_symbols.sym
	-- stylua: ignore
	return {
		-- Main text elements
		Normal { fg = bw.light },
		Comment { fg = bw.lightgrey, gui = italic },
		-- Statement { fg = primary.light, gui = italic },
		Statement { fg = bw.light.darken(20), gui = bold .. ','.. italic },
		Operator { fg = bw.bright, gui = bold },
		-- Constant { fg = tertiary.mid },
		-- String { fg = secondary.mid },
		Constant { fg = bw.lightgrey },
		String { fg = bw.lightgrey },
		Special { fg = bw.lightgrey },
		Identifier { fg = bw.light },
		SignColumn { Normal, bg = bw.dark },
		Type { fg = bw.bright, gui = bold },
		PreProc { Statement },
		Title { fg = primary.light, gui = bold },
		Directory { Title, gui = '' },
		SpecialKey { fg = primary.light.lighten(40) },
		MatchParen { bg = primary.dark },
		Function { Normal },
		Variable { Normal },
		Delimiter { Special },
		sym"@variable" { Identifier },

		LspInlayHint { Comment, bg = bw.dark.lighten(5), fg = bw.lightgrey.lighten(10) },

		-- Treesitter elements
		TSFuncBuiltin { fg = bw.bright, gui = italic },

		-- Diagnostics
		DiagnosticError { fg = red.mid },
		DiagnosticWarn { fg = yellow.mid },

		-- Backgrounds
		ColorColumn({ Normal, bg = bw.dark }),
		Pmenu { Normal, bg = bw.grey.darken(20) },
		PmenuSel { Pmenu, bg = bw.light, fg = bw.dark },
		Visual { gui = reverse },
		VertSplit { bg = bw.dark, fg = bw.grey },
		WinSeparator { bg = bw.dark, fg = bw.grey },

		-- Diffs
		DiffAdd({ bg = green.dark, fg = bw.bright }),
		DiffChange { bg = yellow.dark, fg = bw.bright },
		DiffDelete { bg = red.dark, fg = bw.bright },
		DiffText { bg = bw.grey, fg = bw.bright },
		GitSignsAdd { SignColumn, fg = green.mid },
		GitSignsChange { SignColumn, fg = yellow.mid },
		GitSignsDelete { SignColumn, fg = red.mid },

		-- Folds
		Folded({ bg = bw.dark, fg = bw.lightgrey }),
		FoldColumn { bg = bw.dark, fg = bw.lightgrey },

		-- Tabline
		Tabline({ bg = bw.grey.darken(30) }),
		TabLineSel { bg = bw.grey },
		TablineFill { bg = bw.grey.darken(30) },

		-- Window bar
		WinBar({ bg = bw.dark.darken(50) }),
		WinBarNC({ bg = bw.dark.darken(30) }),

		-- Others
		LineNr({ fg = bw.grey }),
		CursorLineNr { fg = bw.grey.lighten(20) },
		Search { bg = bw.grey.saturate(10) },
		WildMenu { Search },
		NonText { LineNr, fg = LineNr.fg.darken(20) },
		Whitespace { LineNr, fg = LineNr.fg.darken(20) },
		Error { bg = red.dark },
		ErrorMsg { Error },
		WarningMsg { Error },
		Todo { bg = yellow.dark, fg = Normal.fg.lighten(50) },

		-- Statusline
		StatusLine({ Normal, bg = bw.grey.darken(40) }),
		StatusLineNC { fg = StatusLine.bg.lighten(10), bg = StatusLine.bg.darken(25) },
		StatusLineAlt { Normal, bg = bw.grey, fg = bw.light },
		StatusLineModeNormal { StatusLineAlt },
		StatusLineModeInsert { Normal, bg = blue.dark, fg = bw.light },
		StatusLineModeVisual { Normal, bg = yellow.dark, fg = bw.bright },
		StatusLineModeReplace { Normal, bg = red.dark, fg = bw.light },
	}
end)
