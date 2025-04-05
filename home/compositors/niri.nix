{ config, inputs, osConfig, lib, pkgs, ... }:

{
  imports = [ inputs.niri-flake.homeModules.niri ];

  config = lib.mkIf (osConfig.my.desktop.compositor == "niri") {
    programs.niri = let
      color-focused-background = config.my.theme.accent-background;
      color-focused-text = config.my.theme.accent-text;
      color-focused-inactive = config.my.theme.background-primary;
      color-unfocused = config.my.theme.background-secondary;
      color-text = config.my.theme.text;
      color-urgent = config.my.theme.error;
    in {
      enable = true;
      package = pkgs.niri;

      settings = {
        input = {
          focus-follows-mouse.enable = true;

          keyboard.xkb = {
            layout = "de";
            model = "pc101";
            options = "caps:escape";
            variant = "nodeadkeys";
          };

          touchpad = { disabled-on-external-mouse = true; };
        };

        outputs."PNP(AOC) U34G2G4R3 0x00001553".mode = {
          height = 1440;
          width = 3440;
          refresh = 120.0;
        };

        workspaces =
          lib.genAttrs (map toString [ 1 2 3 4 5 6 7 8 9 ]) (name: { });

        cursor.hide-after-inactive-ms = 5000;

        prefer-no-csd = true;

        layout = {
          gaps = 10;

          focus-ring = {
            enable = true;
            width = 4;
            active.color = color-focused-background;
          };

          tab-indicator = {
            active.color = color-focused-background;
            inactive.color = color-focused-inactive;
            position = "top";
            width = 8.0;
            hide-when-single-tab = true;
            place-within-column = true;
          };
        };

        environment = {
          NIXOS_OZONE_WL = "1";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          _JAVA_AWT_WM_NONREPARENTING = "1";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        };

        binds = with config.lib.niri.actions; {
          "Mod+Shift+ssharp".action = show-hotkey-overlay;

          # Moving Windows
          "Mod+h".action = focus-column-left;
          "Mod+j".action = focus-window-down;
          "Mod+k".action = focus-window-up;
          "Mod+l".action = focus-column-right;
          "Mod+Shift+h".action = move-column-left;
          "Mod+Shift+j".action = move-window-down;
          "Mod+Shift+k".action = move-window-up;
          "Mod+Shift+l".action = move-column-right;

          "Mod+tab".action = focus-workspace-previous;

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

          # Workspaces
          "Mod+1".action = focus-workspace "1";
          "Mod+2".action = focus-workspace "2";
          "Mod+3".action = focus-workspace "3";
          "Mod+4".action = focus-workspace "4";
          "Mod+5".action = focus-workspace "5";
          "Mod+6".action = focus-workspace "6";
          "Mod+7".action = focus-workspace "7";
          "Mod+8".action = focus-workspace "8";
          "Mod+9".action = focus-workspace "9";
          "Mod+Shift+1".action = move-column-to-workspace "1";
          "Mod+Shift+2".action = move-column-to-workspace "2";
          "Mod+Shift+3".action = move-column-to-workspace "3";
          "Mod+Shift+4".action = move-column-to-workspace "4";
          "Mod+Shift+5".action = move-column-to-workspace "5";
          "Mod+Shift+6".action = move-column-to-workspace "6";
          "Mod+Shift+7".action = move-column-to-workspace "7";
          "Mod+Shift+8".action = move-column-to-workspace "8";
          "Mod+Shift+9".action = move-column-to-workspace "9";

          # Start Applications
          "Mod+q".action = close-window;
          "Mod+Return".action = spawn "kitty";
          "Mod+d".action = spawn [ "rofi" "-show" "drun" "-terminal" "kitty" ];
          "Mod+Ctrl+w".action = spawn "firefox";
          "Mod+Ctrl+y".action = spawn [ "firefox" "-p" "persistent" ];
          "Mod+Ctrl+n".action = spawn [ "kitty" "${pkgs.lf}/bin/lf" ];
          "Mod+Ctrl+e".action = spawn [ "neovide" "--grid" "140x60" ];
          "Print".action = spawn [ "flameshot" "gui" ];

          # layout
          "Mod+w".action = toggle-column-tabbed-display;
          "Mod+s".action = consume-window-into-column;
          "Mod+e".action = expel-window-from-column;
          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Plus".action = set-column-width "+10%";
          "Mod+c".action = center-column;
          "Mod+Space".action = switch-focus-between-floating-and-tiling;
          "Mod+Shift+Space".action = toggle-window-floating;

          # System
          "Mod+Ctrl+Alt+q".action = quit;
        };
      };
    };
  };
}
