{
  config,
  options,
  osConfig,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (osConfig.my.desktop.compositor == "sway") {
    wayland.windowManager.sway =
      let
        modifier = "Mod4";
        terminal = "foot";
        launcher = ''rofi -show combi -terminal ${terminal} -run-command "${pkgs.sway}/bin/swaymsg exec '{cmd}'" -run-shell-command "swaymsg exec {terminal} '{cmd}'"'';
        color-focused-background = config.my.theme.accent-background;
        color-focused-text = config.my.theme.accent-text;
        color-focused-inactive = config.my.theme.background-primary;
        color-unfocused = config.my.theme.background-secondary;
        color-text = config.my.theme.text;
        color-urgent = config.my.theme.error;
      in
      {
        enable = true;
        wrapperFeatures.gtk = true;
        extraSessionCommands = ''
          # enable wayland in electron applications under NixOS
          export NIXOS_OZONE_WL=1

          # workaround for Java GUI applications being broken
          export _JAVA_AWT_WM_NONREPARENTING=1

          export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        '';

        systemd.variables = options.wayland.windowManager.sway.systemd.variables.default ++ [
          # fixes xdg-open with xdg-desktop-portal
          "XDG_DATA_DIRS"
          "PATH"
        ];

        config = {
          output = {
            "AOC U34G2G4R3 0x00001553" = {
              mode = "3440x1440@120Hz";
            };
          };

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
            "${modifier}+tab" = "workspace back_and_forth";

            # Start Applications
            "${modifier}+Return" = "exec ${terminal}";
            "${modifier}+d" = "exec ${launcher}";
            "${modifier}+q" = "kill";

            "${modifier}+Control+w" = "exec firefox";
            "${modifier}+Control+y" = "exec firefox -p persistent";
            "${modifier}+Control+n" = "exec ${terminal} ${pkgs.lf}/bin/lf";
            "${modifier}+Control+e" = "exec neovide --grid 140x60";
            "Print" = "exec flameshot gui";

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

            "${modifier}+n" = "mark --toggle replace";
            "${modifier}+Shift+n" =
              ''swap container with mark replace; [con_mark="replace"] focus; unmark replace'';

            # System (Exit, Shutdown, ...)
            "Control+Mod4+Mod1+q" = "exit";
            "Control+Mod4+Mod1+l" =
              "exec systemctl --user --quiet start swayidle.service && pkill -SIGRTMIN+10 waybar && loginctl lock-session";
            "Control+Mod4+Mod1+s" =
              "exec systemctl --user --quiet start swayidle.service && pkill -SIGRTMIN+10 waybar && systemctl suspend";
            "Control+Mod4+Mod1+p" = "exec systemctl poweroff";
            "Control+Mod4+Mod1+r" = "exec systemctl reboot";
            "Control+Mod4+Mod1+h" =
              "exec systemctl --user --quiet start swayidle.service && pkill -SIGRTMIN+10 waybar && systemctl hibernate";

            "${modifier}+r" = "mode resize";
          };

          assigns = {
            "5" = [ { app_id = "^thunderbird$"; } ];
            "6" = [
              { app_id = "^vesktop$"; }
              { app_id = "^Element$"; }
            ];
            "7" = lib.mkIf osConfig.my.gaming.enable [ { class = "^[Ss]team$"; } ];
          };

          bars = [ ]; # Waybar is started by systemd

          window.commands = lib.mkIf osConfig.my.gaming.enable [
            # floating and inhibit_idle for all windows on workspace 7 except steam, because not all steam games match [class="^steam_app.*$"], e.g. cs2
            {
              command = "inhibit_idle visible; floating enable";
              criteria = {
                workspace = "^7$";
              };
            }
            {
              command = "inhibit_idle none; floating disable";
              criteria = {
                class = "^[Ss]team$";
                title = "^[Ss]team$";
              };
            }
          ];

          seat = {
            "*" = {
              hide_cursor = "5000";
            };
          };

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
              border = color-focused-background;
              background = color-focused-background;
              text = color-focused-text;
              indicator = "#ffffff";
              childBorder = color-focused-background;
            };

            focusedInactive = {
              border = color-focused-inactive;
              background = color-focused-inactive;
              text = color-text;
              indicator = "#ffffff";
              childBorder = color-focused-inactive;
            };

            unfocused = {
              border = color-unfocused;
              background = color-unfocused;
              text = color-text;
              indicator = "#ffffff";
              childBorder = color-unfocused;
            };

            urgent = {
              border = color-urgent;
              background = color-urgent;
              text = color-text;
              indicator = "#ffffff";
              childBorder = color-urgent;
            };
          };

          startup = [
            {
              command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            }
          ];
        };

        extraConfig =
          let
            outputForWorkspaceNumber =
              n: if n <= 10 then osConfig.my.desktop.screens.primary else osConfig.my.desktop.screens.secondary;

            keyForWorkspaceNumber =
              n:
              if n <= 9 then
                "${toString n}"
              else if n == 10 then
                "0"
              else
                lib.elemAt [ "u" "i" "o" "p" "udiaeresis" ] (n - 11);

            workspaceKeybinding =
              numbers:
              (lib.strings.concatLines (
                lib.flatten (
                  map (
                    n:
                    let
                      output = outputForWorkspaceNumber n;
                    in
                    (if (isNull output) then [ ] else [ "workspace ${toString n} output ${output}" ])
                    ++ [
                      "bindsym ${modifier}+${keyForWorkspaceNumber n} workspace ${toString n}"
                      "bindsym ${modifier}+Shift+${keyForWorkspaceNumber n} move container to workspace ${toString n}"
                    ]
                  ) numbers
                )
              ));
          in
          workspaceKeybinding (lib.range 1 14)
          + ''
            title_align center
            titlebar_border_thickness 0
            titlebar_padding 2 2

            floating_maximum_size -1 x -1

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

            # XWayland title indicator
            for_window [shell="xwayland"] title_format "%title [XWayland]"

            # Make first workspace floating
            for_window [workspace="^1$"] floating enable
            for_window [workspace="^6$"] layout tabbed

            # Force borders for all windows
            for_window [all] border normal

            for_window [class="^zoom$"] floating enable; inhibit_idle open
            for_window [class="^Birdy3d$"] floating enable
            for_window [app_id="^thunderbird$" title="^[1-9]* Erinnerung(en)?$"] floating enable
            for_window [app_id="^firefox$" title="^(Picture-in-Picture|Bild-im-Bild)$"] floating enable; sticky enable
            for_window [app_id="^rpcs3$"] inhibit_idle visible
            for_window [class="^dolphin-emu$"] inhibit_idle visible
            for_window [app_id="^org.kde.kdeconnect.handler$"] floating enable
            for_window [app_id="^xdg-desktop-portal-gtk$"] floating enable

            for_window [app_id="^org.yuzu_emu.yuzu$"] inhibit_idle visible

            seat * shortcuts_inhibitor disable
            set $mode_hotkeygrab Hotkey grab: mod+Shift+z to exit
            bindsym ${modifier}+Shift+z mode "$mode_hotkeygrab"
            mode "$mode_hotkeygrab" {
                bindsym ${modifier}+Shift+z mode "default"
            }

            include ~/.config/sway/conf.d/*
          '';
      };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
      ];
      config.sway = {
        default = "gtk";
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
        "org.freedesktop.impl.portal.Inhibit" = "none";
        "org.freedesktop.impl.portal.Settings" = "kde";
      };
    };

    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 10;
          command = "${pkgs.procps}/bin/pidof swaylock && ${pkgs.sway}/bin/swaymsg 'output * power off'";
          resumeCommand = "${pkgs.procps}/bin/pidof swaylock && ${pkgs.sway}/bin/swaymsg 'output * power on' && ${pkgs.systemd}/bin/systemctl --user restart wlsunset.service";
        }
        {
          timeout = 600;
          command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
          resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on' && ${pkgs.systemd}/bin/systemctl --user restart wlsunset.service";
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

    home.packages = with pkgs; [
      swaybg
    ];
  };
}
