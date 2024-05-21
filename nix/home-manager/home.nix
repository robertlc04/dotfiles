{ config, pkgs, ... } : {

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "robert";
    homeDirectory = "/home/robert";
    stateVersion = "23.11";

    
    packages = with pkgs; [
      fastfetch
      links2
      google-chrome
      spotify
      anki 
      imagemagick
      wlr-randr
      usbutils
      glib
      wlogout
      swappy
      grim
      swaylock-effects
      slurp
      wofi
      ];
  };

  programs.ags = {
      enable = true;

      # configDir = /home/robert/.config/ags;

      extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
      ];
    };

  gtk.enable = true;
  qt.enable = true;

  qt.platformTheme = "gtk";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;

  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Ice";

  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3";

  imports = [ ./modules/bundle.nix ];
}
