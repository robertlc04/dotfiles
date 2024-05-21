{
	programs.alacritty = {
		enable = true;

		settings = {
                  general.import = [ "$HOME/.cache/wal/colors-alacritty.toml" ];
                  general.live_config_reload = true;

                  window.opacity = 0.5; 
                  font.normal = {
                          family = "JetBrains Mono";
                          style = "Regular";
                      };
		};
	}; 
}
