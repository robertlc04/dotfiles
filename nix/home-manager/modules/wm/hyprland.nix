{
  wayland.windowManager.hyprland = 
    let 
      mainMod="SUPER";
    in {
    enable = true;
    xwayland.enable = true;

    # Configuration File

    settings = {
      monitor = ",1920x1080,auto,1";

    env = [
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "XCURSOR_SIZE,36"
      "QT_QPA_PLATFORM,wayland"
      "XDG_SCREENSHOTS_DIR,~/Pictures/Screenshots"
    ];

      exec-once = [
        "ags"
        "gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "$HOME/.config/swww/swwwallpaper.sh"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = "yes";
        };

        tablet = {
          output = "eDP-1";
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgb(cdd6f4)";

        layout = "dwindle";
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      master = { new_is_master = "true"; };

      gestures = { workspace_swipe = "off"; };

      decoration = {
        drop_shadow = "yes";

        shadow_range = 4;
        shadow_render_power = 3;

        "col.shadow" = "rgba(1a1a1aee)";

        blur = {
          enabled = "true";
          size = 7;
          passes = 3;
        };

      };

      bind = [
        "${mainMod}, Return, exec, wezterm"
        "${mainMod}, W, killactive,"
        "${mainMod}| Shift, Q, exit,"

        "${mainMod} SHIFT, L, exec, swaylock" # Lock the screen
        "${mainMod}, Q, exec,wlogout -b 2 -c 0 -r 0 -L 530 -R 530 -T 300 -B 300 --protocol layer-shell" # show the logout window
        "${mainMod}, t, pseudo" # dwindle
        "${mainMod} SHIFT, J, togglesplit" # dwindle
        "${mainMod}, F, fullscreen, 0"  # monocle layout
        "${mainMod} SHIFT, F, fullscreen, 1" # monocle layout
        "${mainMod}, V, togglefloating" # Allow a window to float

        "${mainMod}, H, movefocus, l"
        "${mainMod}, L, movefocus, r"
        "${mainMod}, K, movefocus, u"
        "${mainMod}, J, movefocus, d"

        "${mainMod} SHIFT, left,resizeactive,-40 0"
        "${mainMod} SHIFT, right,resizeactive,40 0"
        "${mainMod} SHIFT, up,resizeactive,0 -40"
        "${mainMod} SHIFT, down,resizeactive,0 40"

        ",256, exec, pamixer --default-source -t" # Mic mute key
        ",232, exec, brightnessctl set 10%-" # Screen brightness down FN+F7
        ",233, exec, brightnessctl set 10%+" # Screen brightness up FN+F8
        ",237, exec, brightnessctl -d asus::kbd_backlight set 33%-" # Keyboard brightness down FN+F2
        ",238, exec, brightnessctl -d asus::kbd_backlight set 33%+" # Keyboard brightnes up FN+F3

        ",171, exec, playerctl -p spotify next"
        ",172, exec, playerctl -p spotify play-pause"
        ",173, exec, playerctl -p spotify previous"
        ",174, exec, playerctl -p spotify stop"


      ] ++ (builtins.concatLists(builtins.genList ( # Workspaces
        x: let
          ws = let
            c = (x + 1) / 10;
          in
              builtins.toString(x + 1 - (c * 10));
        in
        [
          "${mainMod}, ${ws}, workspace, name:${toString( x + 1 )}"
          "${mainMod} Shift, ${ws}, movetoworkspace, name:${toString( x + 1 )}"
        ]) 8
      ));

      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      binde = [
        ",122, exec, amixer sset Master $(( $(amixer sget Master | grep -o '[0-9]*%'| uniq | sed 's/%//') - 5 ))%"
        ",123, exec, amixer sset Master $(( $(amixer sget Master | grep -o '[0-9]*%'| uniq | sed 's/%//') + 5 ))%"
      ];

      bindr = [
        "${mainMod}, M, exec, pkill wofi || wofi --show drun"
      ];

      workspace = [
        "1, name: \"1\""
        "2, name: \"2\""
        "3, name: \"3\""
        "4, name: \"4\""
        "5, name: \"5\""
        "6, name: \"6\""
        "7, name: \"7\""
        "8, name: \"8\""
      ];
    };

    extraConfig = ''
    bind = ${mainMod} Shift, D, exec, grim -g "0,0 1920x1080" - | swappy -f - # take a screenshot in principal monitor
    bind = ${mainMod} Shift, M, exec, grim -g "1920,0 1920x1080" - | swappy -f - # take a screenshot in second monitor

    animations {
      enabled = yes

      # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

      bezier = myBezier, 0.05, 0.9, 0.1, 1.05

      animation = windows, 1, 7, myBezier
      animation = windowsOut, 1, 7, default, popin 80%
      animation = border, 1, 10, default
      animation = fade, 1, 7, default
      animation = workspaces, 1, 6, default
    }

    windowrulev2 = stayfocused, title:^()$,class:^(steam)$
    windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$
    windowrule = unset, title:^()$,class:*(asseto)*
    windowrulev2 = tile, title:^()$,class:*(asseto)*

   '';

};	
}
