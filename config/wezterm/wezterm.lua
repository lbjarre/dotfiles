local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Font.
config.font = wezterm.font({
	family = "CaskaydiaCove Nerd Font Mono",
	weight = "Regular",
	-- Disable ligatures.
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})
config.font_size = 11.0
config.line_height = 1.2

-- Color scheme: there are a whole bunch of these available which you can
-- browse in the docs. This was just the first one that seemed decent.
config.color_scheme = "Afterglow"

-- Use the TUI tab bar instead of the native one.
config.use_fancy_tab_bar = false

-- Disable padding in the pane. It's literally free screen real estate.
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Only set RESIZE for window decorations, no TITLE, buying some more screen
-- real estate. NONE does not work with aerospace.
config.window_decorations = "RESIZE"

-- Do not need to update the status bar so often.
config.status_update_interval = 10000 -- milliseconds

local function get_weather()
	-- TODO: How do I a nix executable this into the system path? Absolute path
	-- seems a bit fragile.
	local success, weather, _ = wezterm.run_child_process({ "/run/current-system/sw/bin/wttr" })
	if not success then
		return "~"
	end
	return weather
end

-- Right status bar info.
wezterm.on("update-status", function(window, pane)
	local domain_name = pane:get_domain_name()
	local date <const> = wezterm.strftime("%Y-%m-%d %H:%M")
	local _, weather = pcall(get_weather)
	local status = domain_name .. " | " .. weather .. " | " .. date

	window:set_right_status(wezterm.format({ { Text = status } }))
end)

config.keys = {
	{
		mods = "SUPER|ALT",
		key = ",",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab: ",
			initial_value = "",
			action = wezterm.action_callback(function(window, pane, line)
				_ = pane
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		mods = "SUPER|ALT",
		key = "p",
		action = wezterm.action.ActivateCommandPalette,
	},
	{
		mods = "SUPER|ALT",
		key = "f",
		action = wezterm.action_callback(function(window, pane)
			local workspaces = wezterm.mux.get_workspace_names()
			local choices = {}
			for _, ws in ipairs(workspaces) do
				table.insert(choices, { id = ws, label = ws })
			end

			window:perform_action(
				wezterm.action.InputSelector({
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						if not id and not label then
							wezterm.log_info("cancelled")
							return
						end
						inner_window:perform_action(
							wezterm.action.SwitchToWorkspace({
								name = label,
								spawn = {
									label = "Workspace: " .. label,
								},
							}),
							inner_pane
						)
					end),
					title = "Choose Workspace",
					choices = choices,
					fuzzy = true,
					fuzzy_description = "Fuzzy find and/or make a workspace: ",
				}),
				pane
			)
		end),
	},
}

return config
