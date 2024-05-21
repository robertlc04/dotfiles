{
  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    extraConfig = ''
    -- Globals
    local wezterm = require('wezterm')

    -- Config
    local config = {}

    if wezterm.config_builder then
      config = wezterm.config_builder()
    end

    config:set_strict_mode(true)

    -- Scheme

    config.color_scheme = '/home/robert/.cache/wal/colors-wezterm.toml'
    local colors, _ = wezterm.color.load_scheme(config.color_scheme)
    config.colors = colors

    config.colors.foreground = colors.ansi[2]

    -- Defaults
    config.hide_tab_bar_if_only_one_tab = true
    config.enable_wayland = false
    config.window_background_opacity = 0.3
    config.use_fancy_tab_bar = false

    -- Watcher
    wezterm.add_to_config_reload_watch_list('/home/robert/.cache/wal/colors-wezterm.toml'
    )

    wezterm.log_info(config)

    return config
      '';
  };
}
