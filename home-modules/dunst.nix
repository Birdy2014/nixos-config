{ pkgs, ... }:

{
  services.dunst = {
    enable = true;

    settings = {
      global = {
        width = 300;
        height = 200;
        offset = "30x20";
        frame_width = 1;
        font = "monospace 10";
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst";
        format = "<b>%s</b>\\n%b";
        markup = "full";
      };

      urgency_low = {
        background = "#282828";
        foreground = "#d4be98";
        timeout = 10;
      };

      urgency_normal = {
        background = "#282828";
        foreground = "#a9b665";
        timeout = 15;
      };

      urgency_critical = {
        background = "#282828";
        foreground = "#ea6962";
        timeout = 0;
      };
    };
  };
}
