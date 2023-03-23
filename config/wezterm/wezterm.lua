local wezterm = require("wezterm")

return {
	-- Setup font, with a Nerd Font fallback.
	font = wezterm.font_with_fallback({
		"Caskaydia Cove",
		{ family = "Symbols Nerd Font Mono", scale = 0.75 },
	}),
	-- Font sizes
	font_size = 14.0,
	line_height = 1.1,
	-- Disable ligatures
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	-- Color scheme: there are a whole bunch of these available which you can
	-- browse in the docs. This was just the first one that seemed decent.
	color_scheme = "Afterglow",
	-- Disable the top bar for tabs: still gonna use tmux
	hide_tab_bar_if_only_one_tab = true,
	-- Disable padding in the pane. It's literally free screen real estate.
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}
