-- Globals
local wezterm = require('wezterm')
local config = {}

-- Scheme
config.color_scheme_dirs = { '/home/robert/.cache/wal/' }

-- Defaults
config.hide_tab_bar_if_only_one_tab = true
config.enable_wayland = true
config.window_background_opacity = 0.1

return config
