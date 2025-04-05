{
  config,
  inputs,
  osConfig,
  myLib,
  lib,
  pkgs,
  ...
}:

# TODO: idle inhibit: something like https://git.madhouse-project.org/algernon/ala-lape
# TODO: Find a way to remove the indexed workspace at end of each monitor or switch away from named workspaces like recommended in the niri wiki?

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
        workspaces =
          let
            inherit (osConfig.my.desktop) screens;
          in
          lib.genList (
            x:
            let
              n = x + 1;
            in
            {
              name = myLib.zeroPad 2 (toString n);
              output = if n <= 9 then screens.primary else screens.secondary;
              key = if n <= 9 then (toString n) else lib.elemAt [ "u" "i" "o" "p" "udiaeresis" ] (n - 10);
            }
          ) (if isNull screens.secondary then 9 else 14);
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
            };
          };

          outputs."PNP(AOC) U34G2G4R3 0x00001553".mode = {
            height = 1440;
            width = 3440;
            refresh = 120.0;
          };

          workspaces = lib.listToAttrs (
            map (workspace: {
              name = workspace.name;
              value.open-on-output = workspace.output;
            }) workspaces
          );

          cursor.hide-after-inactive-ms = 5000;

          prefer-no-csd = true;

          overview.backdrop-color = color-background-dark;

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
              { proportion = 1. / 3.; }
              { proportion = 1. / 2.; }
              { proportion = 2. / 3.; }
            ];

            default-column-width.proportion = 1. / 3.;
          };

          environment = {
            NIXOS_OZONE_WL = "1";
            ELECTRON_OZONE_PLATFORM_HINT = "auto";
            _JAVA_AWT_WM_NONREPARENTING = "1";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
            DISPLAY = ":0"; # xwayland-satellite
          };

          switch-events.lid-close.action.spawn = [
            "${pkgs.swaylock}/bin/swaylock"
            "-f"
          ];

          spawn-at-startup = [
            {
              command = [ "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" ];
            }
            {
              command = [
                "${pkgs.keepassxc}/bin/keepassxc"
                "--minimized"
              ];
            }
            {
              command = [ (lib.getExe pkgs.xwayland-satellite) ];
            }
          ];

          window-rules = [
            {
              clip-to-geometry = true;
              shadow.enable = true;
            }
            {
              matches = [ { app-id = "^thunderbird$"; } ];
              open-on-workspace = "05";
              open-maximized = true;
              open-focused = false;
            }
            {
              matches = [ { app-id = "^vesktop$"; } ];
              open-on-workspace = "06";
              default-column-width.proportion = 1. / 2.;
              open-focused = false;
            }
            {
              matches = [ { app-id = "^Element$"; } ];
              open-on-workspace = "06";
              default-column-width.proportion = 1. / 2.;
              open-focused = false;
            }
            {
              matches = [ { app-id = "^org.keepassxc.KeePassXC$"; } ];
              open-floating = true;
              block-out-from = "screen-capture";
            }
            {
              matches = [
                {
                  # x11 class
                  app-id = "^steam$";
                }
              ];
              open-on-workspace = "07";
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
              "Mod+D".action = spawn [
                "rofi"
                "-show"
                "drun"
                "-terminal"
                terminal
                "-run-command"
                "niri msg action spawn -- '{cmd}'"
                "-run-shell-command"
                "niri msg action spawn -- {terminal} '{cmd}'"
              ];
              "Mod+Ctrl+W".action = spawn "firefox";
              "Mod+Ctrl+Y".action = spawn [
                "firefox"
                "-p"
                "persistent"
              ];
              "Mod+Ctrl+N".action = spawn [
                terminal
                "${pkgs.lf}/bin/lf"
              ];
              "Mod+Ctrl+E".action = spawn [
                "neovide"
                "--grid"
                "140x60"
              ];
              "Print".action = screenshot-screen;
              "Shift+Print".action = screenshot;

              # layout
              "Mod+W".action = toggle-column-tabbed-display;
              "Mod+odiaeresis".action = consume-or-expel-window-left;
              "Mod+adiaeresis".action = consume-or-expel-window-right;
              "Mod+Ctrl+H".action = set-column-width "-5%";
              "Mod+Ctrl+L".action = set-column-width "+5%";
              "Mod+R".action = switch-preset-column-width;
              "Mod+Shift+R".action = expand-column-to-available-width;
              "Mod+Ctrl+K".action = set-window-height "-5%";
              "Mod+Ctrl+J".action = set-window-height "+5%";
              "Mod+C".action = center-column;
              "Mod+Shift+F".action = fullscreen-window;
              "Mod+F".action = maximize-column;
              "Mod+Space".action = switch-focus-between-floating-and-tiling;
              "Mod+Shift+Space".action = toggle-window-floating;
              "Mod+Shift+tab".action = toggle-overview;

              # monitors
              "Mod+Comma".action = focus-monitor-left;
              "Mod+Period".action = focus-monitor-right;
              "Mod+Shift+Comma".action = move-column-to-monitor-left;
              "Mod+Shift+Period".action = move-column-to-monitor-right;

              # System
              "Mod+Ctrl+Alt+Q".action = quit;
              "Mod+Ctrl+Alt+L".action = spawn [
                "sh"
                "-c"
                "systemctl --user --quiet start swayidle.service && pkill -SIGRTMIN+10 waybar && loginctl lock-session"
              ];
              "Mod+Ctrl+Alt+S".action = spawn [
                "sh"
                "-c"
                "systemctl --user --quiet start swayidle.service && pkill -SIGRTMIN+10 waybar && systemctl suspend"
              ];
              "Mod+Ctrl+Alt+P".action = spawn [
                "systemctl"
                "poweroff"
              ];
              "Mod+Ctrl+Alt+R".action = spawn [
                "systemctl"
                "reboot"
              ];
              "Mod+Ctrl+Alt+H".action = spawn [
                "sh"
                "-c"
                "systemctl --user --quiet start swayidle.service && pkill -SIGRTMIN+10 waybar && systemctl hibernate"
              ];

              # Multimedia Keys
              "Mod+M" = {
                action = spawn [
                  "${pkgs.wireplumber}/bin/wpctl"
                  "set-mute"
                  "@DEFAULT_SOURCE@"
                  "toggle"
                ];
                allow-when-locked = true;
              };
              "XF86AudioMicMute" = {
                action = spawn [
                  "${pkgs.wireplumber}/bin/wpctl"
                  "set-mute"
                  "@DEFAULT_SOURCE@"
                  "toggle"
                ];
                allow-when-locked = true;
              };
              "XF86AudioMute" = {
                action = spawn [
                  "${pkgs.wireplumber}/bin/wpctl"
                  "set-mute"
                  "@DEFAULT_SINK@"
                  "toggle"
                ];
                allow-when-locked = true;
              };
              "XF86AudioLowerVolume" = {
                action = spawn [
                  "${pkgs.wireplumber}/bin/wpctl"
                  "set-volume"
                  "@DEFAULT_SINK@"
                  "1%-"
                  "--limit"
                  (toString (osConfig.my.home.max-volume / 100.0))
                ];
                allow-when-locked = true;
              };
              "XF86AudioRaiseVolume" = {
                action = spawn [
                  "${pkgs.wireplumber}/bin/wpctl"
                  "set-volume"
                  "@DEFAULT_SINK@"
                  "1%+"
                  "--limit"
                  (toString (osConfig.my.home.max-volume / 100.0))
                ];
                allow-when-locked = true;
              };
              "XF86AudioPlay" = {
                action = spawn [
                  "playerctl-current"
                  "play-pause"
                ];
                allow-when-locked = true;
              };
              "XF86AudioPrev" = {
                action = spawn [
                  "playerctl-current"
                  "previous"
                ];
                allow-when-locked = true;
              };
              "XF86AudioNext" = {
                action = spawn [
                  "playerctl-current"
                  "next"
                ];
                allow-when-locked = true;
              };
              "XF86MonBrightnessDown" = {
                action = spawn [
                  "${pkgs.brightnessctl}/bin/brightnessctl"
                  "set"
                  "5%-"
                ];
                allow-when-locked = true;
              };
              "XF86MonBrightnessUp" = {
                action = spawn [
                  "${pkgs.brightnessctl}/bin/brightnessctl"
                  "set"
                  "+5%"
                ];
                allow-when-locked = true;
              };

              # misc
              "Mod+Shift+Z".action = toggle-keyboard-shortcuts-inhibit;
            }
            // lib.listToAttrs (
              lib.flatten (
                with config.lib.niri.actions;
                map (workspace: [
                  {
                    name = "Mod+${workspace.key}";
                    value.action = focus-workspace workspace.name;
                  }
                  {
                    name = "Mod+Shift+${workspace.key}";
                    value.action = move-column-to-workspace workspace.name;
                  }
                ]) workspaces
              )
            );
        };
      };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
      ];
      config.sway = {
        default = "gnome";
        "org.freedesktop.impl.portal.Inhibit" = "none";
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
            command = "niri msg action power-off-monitors";
            resumeCommand = "niri msg action power-on-monitors && ${pkgs.systemd}/bin/systemctl --user restart wlsunset.service";
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
  };
}
