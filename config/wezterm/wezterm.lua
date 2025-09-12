local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Font.
config.font = wezterm.font({
	family = "Fira Code",
	weight = "Regular",
	-- Disable ligatures.
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})
config.font_size = 12.0
config.line_height = 1.2

-- Color scheme: there are a whole bunch of these available which you can
-- browse in the docs. This was just the first one that seemed decent.
config.color_scheme = "Afterglow"

-- Use the TUI tab bar instead of the native one.
config.use_fancy_tab_bar = false
-- Disable the top bar if there is only one tab: in case multiplexing is still
-- done in tmux.
config.hide_tab_bar_if_only_one_tab = true

-- Disable padding in the pane. It's literally free screen real estate.
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Do not need to update the status bar so often.
config.status_update_interval = 5000 -- milliseconds

-- Right status bar info.
wezterm.on("update-right-status", function(window, _pane)
	local date = wezterm.strftime("%Y-%m-%d %H:%M")

	local _, weather, _ = wezterm.run_child_process({ "/Users/skr/bin/wttr" })
	weather = weather:gsub("%s*$", "") -- Trim trailing newline

	window:set_right_status(wezterm.format({
		{ Text = weather .. " | " .. date },
	}))
end)

return config
