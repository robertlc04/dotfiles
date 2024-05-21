{pkgs,...}: {
	nixpkgs.config = {
		allowUnfree = true;
	};

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
		curl

		# Home Manager
    home-manager

		# Wallpaper Manager
		swww

		# Wayland
		xwayland

		# Window Manager
		hyprland
		xdg-desktop-portal-hyprland
		pkgs.libsForQt5.sddm
    pkgs.libsForQt5.qt5.qtquickcontrols2   
    pkgs.libsForQt5.qt5.qtgraphicaleffects
    libinput
    libinput-gestures

    # Ags Bar 
    bun

		# Wacom
		rnote
		
		#Utils
		fastfetch
		zip
		unzip
		brightnessctl
    pamixer
    playerctl

    # Nix Utils
    nix-prefetch-git

    # Gaming
    steam
    bottles
    protonup
    dconf

    # Icons
    gnome.adwaita-icon-theme

    # Sddm Need
    qt6.qtsvg
    qt6.qt5compat
    qt6.qtdeclarative

    # Rust
    rustup
    cargo
    gcc
  ];	

  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    twemoji-color-font
    font-awesome
    powerline-fonts
    powerline-symbols
    material-design-icons
    monotone
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];
}
