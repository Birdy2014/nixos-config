{ osConfig, pkgs, ... }:

{
  imports = [ ./kitty.nix ./rofi ./waybar ./themes.nix ];

  wayland.windowManager.sway = let
    modifier = "Mod4";
    terminal = "kitty";
    launcher = ''
      rofi -show combi -terminal ${terminal} -run-command "${pkgs.sway}/bin/swaymsg exec '{cmd}'" -run-shell-command "swaymsg exec {terminal} '{cmd}'"'';
    color-accent = "#a96b2c";
    color-bg = "#45403d";
    color-bg-dark = "#282828";
    color-fg = "#d4be98";
    color-urgent = "#ea6962";
  in {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      # enable wayland in firefox and thunderbird
      export MOZ_ENABLE_WAYLAND=1
      # enable wayland in electron applications under NixOS
      export NIXOS_OZONE_WL=1

      # workaround for Java GUI applications being broken
      export _JAVA_AWT_WM_NONREPARENTING=1

      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    '';

    config = {
      output = { "AOC U34G2G4R3 0x00001553" = { mode = "3440x1440@120Hz"; }; };

      input = {
        "type:keyboard" = {
          xkb_layout = "de";
          xkb_variant = "nodeadkeys";
          xkb_options = "caps:escape";
          xkb_model = "pc101";
          repeat_delay = "660";
          repeat_rate = "25";
        };

        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "disabled";
        };
      };

      floating.modifier = "${modifier}";

      keybindings = {
        # Moving Windows
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "${modifier}+Shift+h" = "move left 20px";
        "${modifier}+Shift+j" = "move down 20px";
        "${modifier}+Shift+k" = "move up 20px";
        "${modifier}+Shift+l" = "move right 20px";
        "${modifier}+Ctrl+Shift+h" = "move left 40px";
        "${modifier}+Ctrl+Shift+j" = "move down 40px";
        "${modifier}+Ctrl+Shift+k" = "move up 40px";
        "${modifier}+Ctrl+Shift+l" = "move right 40px";

        # Workspaces
        "${modifier}+1" = "workspace 1";
        "${modifier}+2" = "workspace 2";
        "${modifier}+3" = "workspace 3";
        "${modifier}+4" = "workspace 4";
        "${modifier}+5" = "workspace 5";
        "${modifier}+6" = "workspace 6";
        "${modifier}+7" = "workspace 7";
        "${modifier}+8" = "workspace 8";
        "${modifier}+9" = "workspace 9";
        "${modifier}+Shift+1" = "move container to workspace 1";
        "${modifier}+Shift+2" = "move container to workspace 2";
        "${modifier}+Shift+3" = "move container to workspace 3";
        "${modifier}+Shift+4" = "move container to workspace 4";
        "${modifier}+Shift+5" = "move container to workspace 5";
        "${modifier}+Shift+6" = "move container to workspace 6";
        "${modifier}+Shift+7" = "move container to workspace 7";
        "${modifier}+Shift+8" = "move container to workspace 8";
        "${modifier}+Shift+9" = "move container to workspace 9";

        "${modifier}+tab" = "workspace back_and_forth";

        # Start Applications
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${launcher}";
        "${modifier}+q" = "kill";

        "${modifier}+Control+w" = "exec firefox";
        "${modifier}+Control+y" = "exec firefox -p persistent";
        "${modifier}+Control+n" = "exec ${terminal} ${pkgs.lf}/bin/lf";
        "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui";

        # Layout
        "${modifier}+c" = "split none";
        "${modifier}+v" = "split vertical";
        "${modifier}+b" = "split horizontal";

        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        "${modifier}+a" = "focus parent";
        "${modifier}+y" = "focus child";
        "${modifier}+x" = "sticky toggle";
        "${modifier}+f" = "fullscreen toggle";

        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+Shift+space" = "floating toggle";

        # System (Exit, Shutdown, ...)
        "Control+Mod4+Mod1+q" = "exit";
        "Control+Mod4+Mod1+l" =
          "exec systemctl --user --quiet start swayidle.service && pkill -SIGRTMIN+10 waybar && loginctl lock-session";
        "Control+Mod4+Mod1+s" =
          "exec systemctl --user --quiet start swayidle.service && pkill -SIGRTMIN+10 waybar && systemctl suspend";
        "Control+Mod4+Mod1+p" = "exec systemctl poweroff";
        "Control+Mod4+Mod1+r" = "exec systemctl reboot";
        "Control+Mod4+Mod1+h" = "exec systemctl hibernate";

        "${modifier}+o" = "scratchpad show";
        "${modifier}+r" = "mode resize";
      };

      assigns = {
        "5" = [{ class = "^[Ss]team$"; }];
        "6" = [{ app_id = "^thunderbird$"; }];
        "7" = [{ app_id = "^discord$"; }];
      };

      bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];

      seat = { "*" = { hide_cursor = "5000"; }; };

      window.titlebar = true;

      fonts = {
        names = [ "sans-serif" ];
        size = 10.0;
      };

      gaps.inner = 5;

      focus.newWindow = "urgent";

      modes = {
        resize = {
          h = "resize shrink width 10px";
          j = "resize grow height 10px";
          k = "resize shrink height 10px";
          l = "resize grow width 10px";

          Return = "mode default";
          Escape = "mode default";
        };
      };

      colors = {
        focused = {
          border = color-accent;
          background = color-accent;
          text = "#1d2021";
          indicator = "#ffffff";
          childBorder = color-accent;
        };

        focusedInactive = {
          border = color-bg;
          background = color-bg;
          text = color-fg;
          indicator = "#ffffff";
          childBorder = color-bg;
        };

        unfocused = {
          border = color-bg-dark;
          background = color-bg-dark;
          text = color-fg;
          indicator = "#ffffff";
          childBorder = color-bg-dark;
        };

        urgent = {
          border = color-urgent;
          background = color-urgent;
          text = color-fg;
          indicator = "#ffffff";
          childBorder = color-urgent;
        };
      };

      startup = [
        { command = "dbus-update-activation-environment --systemd --all"; }
        {
          command =
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        }
        { command = "${pkgs.keepassxc}/bin/keepassxc"; }
      ];
    };

    extraConfig = ''
      title_align center
      titlebar_border_thickness 0
      titlebar_padding 2 2

      # Multimedia Keys
      bindsym --locked ${modifier}+m exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle
      bindsym --locked XF86AudioMicMute exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle
      bindsym --locked XF86AudioMute exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle
      bindsym --locked XF86AudioLowerVolume exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 1%- --limit ${
        toString (osConfig.my.home.max-volume / 100.0)
      }
      bindsym --locked XF86AudioRaiseVolume exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 1%+ --limit ${
        toString (osConfig.my.home.max-volume / 100.0)
      }
      bindsym --locked XF86AudioPlay exec playerctl-current play-pause
      bindsym --locked XF86AudioPrev exec playerctl-current previous
      bindsym --locked XF86AudioNext exec playerctl-current next
      bindsym --locked XF86MonBrightnessDown exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
      bindsym --locked XF86MonBrightnessUp exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%

      # Ugly workaround for sway starting on workspace 10 because it would be defined first in the "keybindings" attribute set.
      bindsym ${modifier}+0 workspace 10
      bindsym ${modifier}+Shift+0 move container to workspace 10

      # XWayland title indicator
      for_window [shell="xwayland"] title_format "%title [XWayland]"

      # Make first workspace floating
      for_window [workspace="^1$"] floating enable

      # Force borders for all windows
      for_window [app_id=".*"] border normal
      for_window [class=".*"] border normal

      # floating and inhibit_idle for all windows on workspace 5 except steam, because not all steam games match [class="^steam_app.*$"], e.g. cs2
      for_window [workspace="^5$"] inhibit_idle open; floating enable
      for_window [class="^[Ss]team$"] inhibit_idle none; floating disable

      for_window [class="^zoom$"] floating enable; inhibit_idle open
      for_window [class="^Birdy3d$"] floating enable
      for_window [app_id="^thunderbird$" title="^[1-9]* Erinnerung(en)?$"] floating enable
      for_window [app_id="^firefox$" title="^(Picture-in-Picture|Bild-im-Bild)$"] floating enable; sticky enable
      for_window [app_id="^rpcs3$"] inhibit_idle visible
      for_window [class="^dolphin-emu$"] inhibit_idle visible
      for_window [app_id="^org.kde.kdeconnect.handler$"] floating enable

      # Scratchpad
      for_window [app_id="org.keepassxc.KeePassXC"] move scratchpad
      for_window [app_id="org.keepassxc.KeePassXC" title=".*Unlock Database.*"] move workspace current; move position center

      seat * shortcuts_inhibitor disable
      set $mode_hotkeygrab Hotkey grab: mod+Shift+z to exit
      bindsym ${modifier}+Shift+z mode "$mode_hotkeygrab"
      mode "$mode_hotkeygrab" {
          bindsym ${modifier}+Shift+z mode "default"
      }

      include ~/.config/sway/conf.d/*
    '';
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 10;
        command =
          "${pkgs.procps}/bin/pidof swaylock && ${pkgs.sway}/bin/swaymsg 'output * power off'";
        resumeCommand =
          "${pkgs.procps}/bin/pidof swaylock && ${pkgs.sway}/bin/swaymsg 'output * power on'";
      }
      {
        timeout = 600;
        command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
      }
      {
        timeout = 605;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
  };

  programs.swaylock = {
    enable = true;
    settings = { color = "282828"; };
  };

  services.wlsunset = {
    enable = true;
    latitude = "50.1";
    longitude = "8.7";
  };

  home.packages = with pkgs; [ swaybg libnotify wl-clipboard ];
}
