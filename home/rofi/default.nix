{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    font = "monospace 12";

    theme = "${pkgs.writeText "rofi-theme.rasi" (with config.my.theme; ''
      * {
        bg-col: ${background-primary};
        bg-col-light: ${background-primary};
        border-col: ${background-primary};
        selected-col: ${background-primary};
        selected-mode: ${accent};
        text: ${text};
        text-selected: ${accent};
        text-inactive: ${text-inactive};
      }

      @import "${./theme.rasi}"
    '')}";

    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      modi = "drun,run,ssh";
      show-icons = true;
      parse-known-hosts = false;
      drun-display-format = "{icon} {name}";
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-ssh = "  SSH";
      sidebar-mode = true;
    };
  };
}
