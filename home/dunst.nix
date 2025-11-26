{ config, pkgs, ... }:

{
  services.dunst = {
    enable = true;

    settings =
      let
        inherit (config.my.theme)
          background-secondary
          text
          accent
          red
          ;
      in
      {
        global = {
          width = 300;
          height = "(0, 200)";
          offset = "(30, 20)";
          frame_width = 1;
          font = "monospace 10";
          dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst";
          format = "<b>%s</b>\\n%b";
          markup = "full";
        };

        urgency_low = {
          background = background-secondary;
          foreground = text;
          timeout = 10;
        };

        urgency_normal = {
          background = background-secondary;
          foreground = accent;
          timeout = 15;
        };

        urgency_critical = {
          background = background-secondary;
          foreground = red;
          timeout = 0;
        };
      };
  };
}
