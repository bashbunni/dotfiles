{
  lib,
  pkgs,
  ...
}: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Needed for GTK apps to work.
    extraSessionCommands = ''
      export SDL_VIDEODRIVER = wayland
      export QT_QPA_PLATFORM = wayland
      export XDG_SESSION_TYPE = wayland
    '';
    extraPackages = with pkgs; [
      brightnessctl
      foot
      grim
      pulseaudio
      swayidle
      swaylock
      wmenu

      ulauncher
      wl-mirror
      wl-clipboard
    ];
  };

  # Required for Sway as per https://nixos.wiki/wiki/Sway
  security.polkit.enable = true;

  xdg.portal.enable = true;

  environment.etc."sway/config" = let
    mod = "Mod4";
    term = "kitty";

    unpack = set: lib.lists.foldr (a: b: a // b) {} (builtins.attrValues set);

    mod4Keybinds = unpack (builtins.mapAttrs (key: cmd: {"${mod}+${key}" = cmd;}) {
      # General
      "Shift+q" = "kill";
      "Shift+c" = "swaymsg reload";
      "Shift+r" = "swaymsg restart";
      "r" = "mode \"resize\"";
      # Executables
      "Return" = "exec ${term}";
      "d" = "exec --no-startup-id rofi -combi-modi window#drun -show combi -modi combi -show-icons";
      "g" = "exec --no-startup-id rofi -show window";
      "m" = "exec ~/.config/emacs/bin/doom run";
      "F4" = "exec --no-startup-id flameshot gui";
      "Print" = "exec --no-startup-id flameshot screen";
      "Shift+e" = "exec swaynag -t warning -m 'Exit sway?' -B 'Yes, exit sway' 'swaymsg exit'";
      # Layout
      "f" = "fullscreen toggle";
      "s" = "layout stacking";
      "w" = "layout tabbed";
      "e" = "layout toggle split";
      "h" = "split h";
      "v" = "split v";
      "Shift+space" = "floating toggle";
      "space" = "focus mode_toggle";
      "a" = "focus parent";
      # Focus
      "j" = "focus left";
      "k" = "focus down";
      "l" = "focus up";
      "semicolon" = "focus right";
      "Left" = "focus left";
      "Down" = "focus down";
      "Up" = "focus up";
      "Right" = "focus right";
      "o" = "move workspace to output right";
      "Shift+j" = "focus output left";
      "Shift+k" = "focus output right";
      # Move
      "Shift+Left" = "move left";
      "Shift+Down" = "move down";
      "Shift+Up" = "move up";
      "Shift+Right" = "move right";
    });

    generalKeybinds = {
      "Print" = "exec --no-startup-id flameshot gui";
      "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%";
      "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%";
      "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";
    };

    ws = map toString (lib.range 1 9);
    workspaceKeybinds =
      builtins.listToAttrs (
        lib.concatMap (i: [
          {
            name = "${mod}+${i}";
            value = "workspace number ${i}";
          }
          {
            name = "${mod}+Shift+${i}";
            value = "move container to workspace number ${i}";
          }
        ])
        ws
      )
      // {
        "${mod}+0" = "workspace number 10";
        "${mod}+Shift+0" = "move container to workspace number 10";
      };

    allKeybinds = mod4Keybinds // generalKeybinds // workspaceKeybinds;

    keybindings = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (key: cmd: "bindsym ${key} ${cmd}") allKeybinds
    );

    colorAttrs = {
      focused = {
        border = "#EA3AE9";
        background = "#EA3AE9";
        text = "#F8F8F2";
        indicator = "#EA3AE9";
        childBorder = "#EA3AE9";
      };
      focused_inactive = {
        border = "#44475A";
        background = "#44475A";
        text = "#F8F8F2";
        indicator = "#44475A";
        childBorder = "#44475A";
      };
      unfocused = {
        border = "#282A36";
        background = "#282A36";
        text = "#BFBFBF";
        indicator = "#282A36";
        childBorder = "#282A36";
      };
      urgent = {
        border = "#44475A";
        background = "#FF5555";
        text = "#F8F8F2";
        indicator = "#FF5555";
        childBorder = "#FF5555";
      };
      placeholder = {
        border = "#282A36";
        background = "#282A36";
        text = "#F8F8F2";
        indicator = "#282A36";
        childBorder = "#282A36";
      };
      background = {
        border = "#F8F8F2";
        background = "";
        text = "";
        indicator = "";
        childBorder = "";
      };
    };

    colors = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: c:
          if name == "background"
          then "client.background ${c.border}"
          else "client.${name} ${c.border} ${c.background} ${c.text} ${c.indicator} ${c.childBorder}"
      )
      colorAttrs
    );

    resizeModeBinds = {
      "j" = "resize shrink width 10 px or 10 ppt";
      "k" = "resize grow height 10 px or 10 ppt";
      "l" = "resize shrink height 10 px or 10 ppt";
      "semicolon" = "resize grow width 10 px or 10 ppt";
      "Left" = "resize shrink width 10 px or 10 ppt";
      "Down" = "resize grow height 10 px or 10 ppt";
      "Up" = "resize shrink height 10 px or 10 ppt";
      "Right" = "resize grow width 10 px or 10 ppt";
      "Return" = "mode \"default\"";
      "Escape" = "mode \"default\"";
      "${mod}+r" = "mode \"default\"";
    };

    resizeMode = ''
      mode "resize" {
        ${lib.concatStringsSep "\n  " (lib.mapAttrsToList (key: cmd: "bindsym ${key} ${cmd}") resizeModeBinds)}
      }
    '';

    startupCmds = [
      "--no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork"
      "--no-startup-id nm-applet"
      "emacs --daemon"
      "dbus-launch waybar"
      "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK"
      "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK"
    ];

    wallpaper = "/home/bashbunni/Pictures/background.png";

    setWallpaper = pkgs.writeShellScriptBin "set-wallpaper" ''
      if [ -f ${wallpaper} ]; then
        swaymsg "output * background ${wallpaper} fill"
      else
        swaymsg "output * bg #00A86B"
      fi
    '';

    startupAlways = [
      "${setWallpaper}/bin/set-wallpaper"
    ];

    startup = lib.concatStringsSep "\n" (
      map (cmd: "exec ${cmd}") startupCmds
      ++ map (cmd: "exec_always ${cmd}") startupAlways
    );

    designAttrs = {
      smart_borders = "on";
      "gaps inner" = "5";
      "gaps outer" = "3";
      default_border = "pixel 3";
      floating_modifier = mod;
      "font pango" = "\"Terminess Nerd Font\" Medium 20";
    };

    design = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (key: val: "${key} ${val}") designAttrs
    );

    mainConfig = ''
      set $mod ${mod}
      set $term ${term}

      ${design}
      ${colors}
      ${startup}
      ${keybindings}
      ${resizeMode}
    '';
  in {
    source = pkgs.writeText "sway-config" mainConfig;
  };
}
