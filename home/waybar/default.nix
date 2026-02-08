{
  config,
  inputs,
  osConfig,
  lib,
  pkgs,
  ...
}:

{
  programs.waybar = {
    enable = true;
    style =
      let
        colorizer = inputs.nix-colorizer;
        increaseChroma =
          hex:
          colorizer.oklch.to.hex (
            let
              okclh = colorizer.hex.to.oklch hex;
            in
            {
              inherit (okclh) L h a;
              C = okclh.C + 5.0e-2;
            }
          );
      in
      with config.my.theme;
      ''
        @define-color accent ${accent};
        @define-color accent-text ${accent-text};
        @define-color background-primary ${background-primary};
        @define-color background-secondary ${background-secondary};
        @define-color background-tertiary ${background-tertiary};
        @define-color text ${text};
        @define-color text-inactive ${text-inactive};
        @define-color black ${black};
        @define-color light-black ${light-black};
        @define-color red ${red};
        @define-color light-red ${light-red};
        @define-color green ${green};
        @define-color light-green ${light-green};
        @define-color yellow ${yellow};
        @define-color light-yellow ${light-yellow};
        @define-color blue ${blue};
        @define-color light-blue ${light-blue};
        @define-color magenta ${magenta};
        @define-color light-magenta ${light-magenta};
        @define-color cyan ${cyan};
        @define-color light-cyan ${light-cyan};
        @define-color white ${white};
        @define-color light-white ${light-white};
        @define-color accent ${increaseChroma accent};
        @define-color accent-complementary ${increaseChroma accent-complementary};
      ''
      + builtins.readFile ./style.css;
    systemd.enable = true;

    # Waybar doesn't properly reload when the settings are changed and has to be restarted.
    # https://github.com/Alexays/Waybar/issues/1881

    settings = {
      mainBar = {
        layer = "top";
        position = "left";
        width = 30;
        margin = "5";
        modules-left = [
          "niri/workspaces"
        ];
        modules-right = [
          "privacy#screenshare"
          "privacy#audio-in"
          "custom/idle-inhibit"
          "systemd-failed-units"
          "pulseaudio"
          "network"
          "backlight"
          "battery"
          "clock"
          "tray"
        ];
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            "01" = "󰋜";
            "02" = "󰈹";
            "03" = "󰗃";
            "04" = "";
            "05" = "󰭹";
            "06" = lib.mkIf osConfig.my.gaming.enable "󰓓";
            default = "";
          };
        };
        "custom/idle-inhibit" = {
          exec = pkgs.writeShellScript "waybar-idle-inhibit.sh" ''
            if systemctl --user --quiet is-active swayidle.service; then
              echo '{"text": "󰈉", "class": "inactive"}'
            else
              echo '{"text": "󰈈", "class": "active"}'
            fi
          '';
          return-type = "json";
          interval = "once";
          exec-on-event = false;
          on-click = pkgs.writeShellScript "waybar-idle-inhibit-click.sh" ''
            if systemctl --user --quiet is-active swayidle.service; then
              systemctl --user --quiet stop swayidle.service
            else
              systemctl --user --quiet start swayidle.service
            fi
            ${pkgs.procps}/bin/pkill -SIGRTMIN+10 waybar
          '';
          signal = 10;
        };
        tray = {
          spacing = 10;
        };
        clock = {
          format = "{:%Y-%m-%d %H:%M} 󰃰";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          rotate = 90;
        };
        backlight = {
          format = "{percent:>3}% {icon}";
          format-icons = [
            ""
            ""
          ];
          rotate = 90;
        };
        battery = {
          states = {
            good = 100;
            ok = 50;
            warning = 30;
            critical = 15;
          };
          format = "{capacity:>3}% {icon}";
          format-charging = "{capacity:>3}% 󰃨";
          format-plugged = "{capacity:>3}% ";
          format-alt = "{time} {icon}";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
          rotate = 90;
        };
        network = {
          interval = 10;
          format-wifi = "{essid} ({signalStrength:>3}%) 󰖩";
          format-ethernet = "{ifname} 󰌘 {bandwidthDownOctets:>3} 󰇚 {bandwidthUpOctets:>3} 󰕒";
          format-linked = "{ifname} (No IP) 󰌚";
          format-disconnected = "Disconnected 󰌙";
          format-tooltip = "{ifname} {ipaddr} {bandwidthDownOctets} 󰇚 {bandwidthUpOctets} 󰕒";
          rotate = 90;
        };
        pulseaudio = {
          format = "{volume:>3}% {icon} {format_source}";
          format-bluetooth = "{volume:>3}% {icon}󰂯 {format_source}";
          format-bluetooth-muted = "{icon}󰂯 {format_source}";
          format-muted = "  {format_source}";
          format-source = "{volume:>3}% 󰍬";
          format-source-muted = "󰍭";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰥰";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰏲";
            default = [
              ""
              ""
              ""
            ];
          };
          max-volume = osConfig.my.home.max-volume;
          on-click = lib.getExe pkgs.pavucontrol;
          rotate = 90;
          ignored-sinks = [ "Easy Effects Sink" ];
        };
        "privacy#screenshare" = {
          icon-size = 12;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
              tooltip-icon-size = 24;
            }
          ];
        };
        "privacy#audio-in" = {
          icon-size = 12;
          modules = [
            {
              type = "audio-in";
              tooltip = true;
              tooltip-icon-size = 24;
            }
          ];
        };
        systemd-failed-units = {
          hide-on-ok = true;
          format = "{nr_failed}";
        };
      };
    };
  };
}
