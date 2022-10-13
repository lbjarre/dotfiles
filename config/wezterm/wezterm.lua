local wezterm = require('wezterm')

return {
  -- Setup font
  font = wezterm.font('Iosevka Nerd Font Mono'),
  font_size = 14.0,
  -- Disable ligatures
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  -- Color scheme: there are a whole bunch of these available which you can
  -- browse in the docs. This was just the first one that seemed decent.
  color_scheme = 'Afterglow',
  -- Disable the top bar for tabs: still gonna use tmux
  enable_tab_bar = false,
  -- Disable padding in the pane. It's literally free screen real estate.
  window_padding = {
    left   = 0,
    right  = 0,
    top    = 0,
    bottom = 0,
  },
}
