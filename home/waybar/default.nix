{ osConfig, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    style = ./style.css;
    systemd.enable = true;

    # Waybar doesn't properly reload when the settings are changed and has to be restarted.
    # https://github.com/Alexays/Waybar/issues/1881

    settings = {
      mainBar = {
        layer = "bottom";
        position = "left";
        width = 30;
        margin = "5";
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-right = [
          "custom/idle-inhibit"
          "pulseaudio"
          "network"
          "backlight"
          "battery"
          "clock"
          "tray"
        ];
        "sway/workspaces" = {
          disable-scroll = true;
          format = "{icon}";
          persistent-workspaces = let
            primaryOutputList =
              if (isNull osConfig.my.desktop.screens.primary) then
                [ ]
              else
                [ osConfig.my.desktop.screens.primary ];
          in {
            "1" = primaryOutputList;
            "2" = primaryOutputList;
            "3" = primaryOutputList;
            "4" = primaryOutputList;
            "5" = primaryOutputList;
            "6" = primaryOutputList;
            "7" = lib.mkIf osConfig.my.gaming.enable primaryOutputList;
          };
          format-icons = {
            "1" = "󰋜";
            "2" = "󰈹";
            "3" = "󰗃";
            "4" = "";
            "5" = "󰇮";
            "6" = "󰙯";
            "7" = lib.mkIf osConfig.my.gaming.enable "󰓓";
            default = "";
          };
        };
        "sway/mode" = {
          format = ''<span style="italic">{}</span>'';
          rotate = 90;
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
        tray = { spacing = 10; };
        clock = {
          format = "{:%Y-%m-%d %H:%M} 󰃰";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          rotate = 90;
        };
        backlight = {
          format = "{percent:>3}% {icon}";
          format-icons = [ "" "" ];
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
          format-icons = [ " " " " " " " " " " ];
          rotate = 90;
        };
        network = {
          interval = 10;
          format-wifi = "{essid} ({signalStrength:>3}%) 󰖩";
          format-ethernet =
            "{ifname} 󰌘 {bandwidthDownOctets:>3} 󰇚 {bandwidthUpOctets:>3} 󰕒";
          format-linked = "{ifname} (No IP) 󰌚";
          format-disconnected = "Disconnected 󰌙";
          format-tooltip =
            "{ifname} {ipaddr} {bandwidthDownOctets} 󰇚 {bandwidthUpOctets} 󰕒";
          rotate = 90;
        };
        pulseaudio = {
          format = "{volume:>3}% {icon} {format_source}";
          format-bluetooth = "{volume:>3}% {icon}󰂯 {format_source}";
          format-bluetooth-muted = "{icon}󰂯 {format_source}";
          format-muted = "{format_source}";
          format-source = "{volume:>3}% 󰍬";
          format-source-muted = "󰍭";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰥰";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰏲";
            default = [ "" "" "" ];
          };
          max-volume = osConfig.my.home.max-volume;
          on-click = "swaymsg exec pavucontrol";
          rotate = 90;
          ignored-sinks = [ "Easy Effects Sink" ];
        };
      };
    };
  };
}
