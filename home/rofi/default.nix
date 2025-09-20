{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    font = "monospace 12";

    theme = "${pkgs.writeText "rofi-theme.rasi" (
      with config.my.theme;
      ''
        * {
          bg-col: ${background-primary};
          bg-col-light: ${background-primary};
          border-col: ${accent-background};
          selected-col: ${background-primary};
          selected-mode: ${accent};
          text: ${text};
          text-selected: ${accent};
          text-inactive: ${text-inactive};
        }

        @import "${./theme.rasi}"
      ''
    )}";

    terminal = "foot";
    extraConfig = {
      modi = "combi,drun,run,ssh";
      combi-modes = "drun,ssh,window";
      show-icons = true;
      parse-known-hosts = false;
      drun-display-format = "{icon} {name}";
      combi-hide-mode-prefix = true;
      window-format = "{c:10} {t}";
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-ssh = "  SSH ";
    };
  };
}
