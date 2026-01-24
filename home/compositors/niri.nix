{
  config,
  inputs,
  osConfig,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:

# TODO: idle inhibit: something like https://git.madhouse-project.org/algernon/ala-lape

{
  imports = [ inputs.niri-flake.homeModules.niri ];

  config = lib.mkIf (osConfig.my.desktop.compositor == "niri") {
    programs.niri =
      let
        terminal = "foot";
        color-focused-background = config.my.theme.accent-background;
        color-focused-inactive = config.my.theme.background-primary;
        color-background-dark = config.my.theme.background-tertiary;
        color-urgent = config.my.theme.error;
        color-red = config.my.theme.red;
      in
      {
        enable = true;
        package = pkgs.niri;

        settings = {
          input = {
            focus-follows-mouse = {
              enable = true;
              max-scroll-amount = "10%";
            };

            keyboard.xkb = {
              layout = "de";
              model = "pc101";
              options = "caps:escape";
              variant = "nodeadkeys";
            };

            touchpad = {
              natural-scroll = false;
              dwt = true;
            };
          };

          outputs."PNP(AOC) U34G2G4R3 0x00001553".mode = {
            height = 1440;
            width = 3440;
            refresh = 120.0;
          };

          workspaces = lib.listToAttrs (
            map (n: {
              name = "0" + toString n;
              value.open-on-output = osConfig.my.desktop.screens.primary;
            }) (lib.range 1 6)
          );

          cursor.hide-after-inactive-ms = 5000;

          prefer-no-csd = true;

          overview = {
            backdrop-color = color-background-dark;
            workspace-shadow.enable = false;
          };

          hotkey-overlay.skip-at-startup = true;

          gestures.hot-corners.enable = false;

          screenshot-path = "${config.xdg.userDirs.pictures}/screenshots/%Y-%m-%d_%H-%M-%S.png";

          layout = {
            gaps = 10;

            focus-ring = {
              enable = true;
              width = 4;
              active.color = color-focused-background;
              urgent.color = color-urgent;
            };

            tab-indicator = {
              active.color = color-focused-background;
              inactive.color = color-focused-inactive;
              position = "top";
              width = 8.0;
              hide-when-single-tab = true;
              place-within-column = true;
            };

            preset-column-widths = [
              { proportion = 1. / 4.; }
              { proportion = 1. / 3.; }
              { proportion = 1. / 2.; }
              { proportion = 2. / 3.; }
              { proportion = 3. / 4.; }
            ];

            default-column-width.proportion = 1. / 3.;

            struts.right = 8;

            # wallpaper is moved to backdrop by layer-rule
            background-color = "transparent";
          };

          environment = {
            NIXOS_OZONE_WL = "1";
            ELECTRON_OZONE_PLATFORM_HINT = "auto";
            _JAVA_AWT_WM_NONREPARENTING = "1";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          };

          switch-events.lid-close.action.spawn = [
            "${pkgs.swaylock}/bin/swaylock"
            "-f"
          ];

          # xwayland-satellite 0.7 can crash when steam starts, 0.8 fixes this
          xwayland-satellite.path = lib.getExe pkgsUnstable.xwayland-satellite;

          window-rules = [
            {
              clip-to-geometry = true;
              shadow = {
                enable = true;
                softness = 20;
                spread = 5;
              };
            }
            {
              matches = [ { is-window-cast-target = true; } ];
              shadow.color = color-red;
            }
            {
              matches = [ { app-id = "^thunderbird$"; } ];
              open-on-workspace = "05";
              open-maximized = true;
              open-focused = false;
            }
            {
              matches = [
                {
                  app-id = "^thunderbird$";
                  title = "^Verfassen: ";
                }
              ];
              open-maximized = false;
              default-column-width.proportion = 0.5;
              open-focused = true;
            }
            {
              matches = [ { app-id = "^vesktop$"; } ];
              open-on-workspace = "05";
              default-column-width.proportion = 1. / 2.;
              open-focused = false;
            }
            {
              matches = [ { app-id = "^Element$"; } ];
              open-on-workspace = "05";
              default-column-width.proportion = 1. / 2.;
              open-focused = false;
            }
            {
              matches = [
                {
                  # x11 class
                  app-id = "^steam$";
                }
              ];
              open-on-workspace = "06";
              open-maximized = true;
            }
            {
              matches = [ { app-id = "^xdg-desktop-portal-gtk$"; } ];
              open-floating = true;
            }
            {
              matches = [ { app-id = "^org.kde.kdeconnect.handler$"; } ];
              open-floating = true;
            }
            {
              matches = [ { app-id = "^zoom$"; } ];
              open-floating = true;
            }
            {
              matches = [ { app-id = "^mpv$"; } ];
              open-floating = true;
            }
          ];

          layer-rules = [
            {
              matches = [ { namespace = "^swww-daemon$"; } ];
              place-within-backdrop = true;
            }
          ];

          binds =
            with config.lib.niri.actions;
            {
              "Mod+Shift+ssharp".action = show-hotkey-overlay;

              # Moving Windows
              "Mod+H".action = focus-column-left;
              "Mod+J".action = focus-window-down;
              "Mod+K".action = focus-window-up;
              "Mod+L".action = focus-column-right;
              "Mod+Shift+H".action = move-column-left;
              "Mod+Shift+J".action = move-window-down;
              "Mod+Shift+K".action = move-window-up;
              "Mod+Shift+L".action = move-column-right;

              "Mod+Tab".action = focus-workspace-previous;

              "Mod+WheelScrollDown" = {
                cooldown-ms = 150;
                action = focus-column-right;
              };
              "Mod+WheelScrollUp" = {
                cooldown-ms = 150;
                action = focus-column-left;
              };
              "Mod+Shift+WheelScrollDown" = {
                cooldown-ms = 150;
                action = move-column-right;
              };
              "Mod+Shift+WheelScrollUp" = {
                cooldown-ms = 150;
                action = move-column-left;
              };

              # Start Applications
              "Mod+Q".action = close-window;
              "Mod+Return".action = spawn terminal;
              "Mod+D".action =
                spawn "rofi" "-show" "combi" "-terminal" terminal "-run-command" "niri msg action spawn -- {cmd}"
                  "-run-shell-command"
                  "niri msg action spawn -- {terminal} {cmd}";
              "Mod+Ctrl+W".action = spawn "firefox";
              "Mod+Ctrl+Y".action = spawn "firefox" "-p" "persistent";
              "Mod+Ctrl+N".action = spawn terminal "${pkgs.lf}/bin/lf";
              "Mod+Ctrl+E".action = spawn "neovide" "--grid" "140x60";
              "Print".action.screenshot-screen = [ ]; # FIXME: Replace with `.. = screenshot-screen` when https://github.com/sodiboo/niri-flake/pull/1078 is merged
              "Shift+Print".action.screenshot = [ ];
              "Ctrl+Print".action.screenshot-window = [ ];

              # layout
              "Mod+W".action = toggle-column-tabbed-display;
              "Mod+odiaeresis".action = consume-or-expel-window-left;
              "Mod+adiaeresis".action = consume-or-expel-window-right;
              "Mod+Ctrl+H".action = switch-preset-column-width-back;
              "Mod+Ctrl+L".action = switch-preset-column-width;
              "Mod+R".action = expand-column-to-available-width;
              "Mod+Ctrl+K".action = set-window-height "-5%";
              "Mod+Ctrl+J".action = set-window-height "+5%";
              "Mod+C".action = center-column;
              "Mod+Shift+F".action = fullscreen-window;
              "Mod+F".action = maximize-column;
              "Mod+Space".action = switch-focus-between-floating-and-tiling;
              "Mod+Shift+Space".action = toggle-window-floating;
              "Mod+Shift+tab".action = toggle-overview;

              # workspaces
              "Mod+I".action = focus-workspace-up;
              "Mod+U".action = focus-workspace-down;
              "Mod+Shift+I".action = move-column-to-workspace-up;
              "Mod+Shift+U".action = move-column-to-workspace-down;
              "Mod+1".action = focus-workspace 1;
              "Mod+2".action = focus-workspace 2;
              "Mod+3".action = focus-workspace 3;
              "Mod+4".action = focus-workspace 4;
              "Mod+5".action = focus-workspace 5;
              "Mod+6".action = focus-workspace 6;
              "Mod+7".action = focus-workspace 7;
              "Mod+8".action = focus-workspace 8;
              "Mod+9".action = focus-workspace 9;
              "Mod+0".action = focus-workspace 10;
              # FIXME: Replace with `..action = move-column-to-workspace 1`... when https://github.com/sodiboo/niri-flake/pull/1078 is merged
              "Mod+Shift+1".action.move-column-to-workspace = 1;
              "Mod+Shift+2".action.move-column-to-workspace = 2;
              "Mod+Shift+3".action.move-column-to-workspace = 3;
              "Mod+Shift+4".action.move-column-to-workspace = 4;
              "Mod+Shift+5".action.move-column-to-workspace = 5;
              "Mod+Shift+6".action.move-column-to-workspace = 6;
              "Mod+Shift+7".action.move-column-to-workspace = 7;
              "Mod+Shift+8".action.move-column-to-workspace = 8;
              "Mod+Shift+9".action.move-column-to-workspace = 9;
              "Mod+Shift+0".action.move-column-to-workspace = 10;

              # monitors
              "Mod+Comma".action = focus-monitor-left;
              "Mod+Period".action = focus-monitor-right;
              "Mod+Shift+Comma".action = move-column-to-monitor-left;
              "Mod+Shift+Period".action = move-column-to-monitor-right;

              # System
              "Mod+Ctrl+Alt+Q".action = quit;
              "Mod+Ctrl+Alt+L".action =
                spawn-sh "systemctl --user --quiet start swayidle.service && pkill -SIGRTMIN+10 waybar && loginctl lock-session";
              "Mod+Ctrl+Alt+S".action =
                spawn-sh "systemctl --user --quiet start swayidle.service && pkill -SIGRTMIN+10 waybar && systemctl suspend";
              "Mod+Ctrl+Alt+P".action = spawn "systemctl" "poweroff";
              "Mod+Ctrl+Alt+R".action = spawn "systemctl" "reboot";
              "Mod+Ctrl+Alt+H".action =
                spawn-sh "systemctl --user --quiet start swayidle.service && pkill -SIGRTMIN+10 waybar && systemctl hibernate";

              # Multimedia Keys
              "Mod+M" = {
                action = spawn "${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_SOURCE@" "toggle";
                allow-when-locked = true;
              };
              "XF86AudioMicMute" = {
                action = spawn "${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_SOURCE@" "toggle";
                allow-when-locked = true;
              };
              "XF86AudioMute" = {
                action = spawn "${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_SINK@" "toggle";
                allow-when-locked = true;
              };
              "XF86AudioLowerVolume" = {
                action = spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_SINK@" "1%-" "--limit" (
                  toString (osConfig.my.home.max-volume / 100.0)
                );
                allow-when-locked = true;
              };
              "XF86AudioRaiseVolume" = {
                action = spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_SINK@" "1%+" "--limit" (
                  toString (osConfig.my.home.max-volume / 100.0)
                );
                allow-when-locked = true;
              };
              "XF86AudioPlay" = {
                action = spawn "playerctl-current" "play-pause";
                allow-when-locked = true;
              };
              "XF86AudioPrev" = {
                action = spawn "playerctl-current" "previous";
                allow-when-locked = true;
              };
              "XF86AudioNext" = {
                action = spawn "playerctl-current" "next";
                allow-when-locked = true;
              };
              "XF86MonBrightnessDown" = {
                action = spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%-";
                allow-when-locked = true;
              };
              "XF86MonBrightnessUp" = {
                action = spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "+5%";
                allow-when-locked = true;
              };

              # misc
              "Mod+Shift+Z".action = toggle-keyboard-shortcuts-inhibit;
              "Mod+Alt+1".action =
                spawn-sh "niri msg action set-window-width 3440; niri msg action set-window-height 1440";
              "Mod+Alt+2".action =
                spawn-sh "niri msg action set-window-width 2560; niri msg action set-window-height 1080";
              "Mod+Alt+3".action =
                spawn-sh "niri msg action set-window-width 2560; niri msg action set-window-height 1440";
              "Mod+Alt+4".action =
                spawn-sh "niri msg action set-window-width 1920; niri msg action set-window-height 1080";
              "Mod+Alt+5".action =
                spawn-sh "niri msg action set-window-width 1280; niri msg action set-window-height 720";
            }
            |> lib.mapAttrs (_: bind: bind // { allow-inhibiting = false; });
        };
      };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
      ];
      config.niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Inhibit" = "none";
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.Settings" = "kde";
      };
    };

    services.swayidle = {
      enable = true;
      timeouts =
        let
          niri = lib.getExe config.programs.niri.package;
        in
        [
          {
            timeout = 10;
            command = "${pkgs.procps}/bin/pidof swaylock && ${niri} msg action power-off-monitors";
            resumeCommand = "${pkgs.procps}/bin/pidof swaylock && ${niri} msg action power-on-monitors && ${pkgs.systemd}/bin/systemctl --user restart wlsunset.service";
          }
          {
            timeout = 600;
            command = "${niri} msg action power-off-monitors";
            resumeCommand = "${niri} msg action power-on-monitors && ${pkgs.systemd}/bin/systemctl --user restart wlsunset.service";
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

    services.swww.enable = true;

    systemd.user.services.niri-process-adjustments = {
      Unit = {
        Description = "Adjust nice and oom_score_adj for niri";
        After = "niri.service";
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = pkgs.writeShellScript "start-niri-process-adjustments.sh" ''
          sleep 5 # The script fails on zilpzalp when run immediately
          pid="$(${lib.getExe' pkgs.procps "pidof"} -s niri)"
          ${lib.getExe' pkgs.util-linux "renice"} -n -10 -p $pid
          ${lib.getExe' pkgs.util-linux "choom"} -n 100 -p $pid
        '';
      };
    };
  };
}
