{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    font = "monospace 12";
    theme = ./gruvbox-dark-custom.rasi;
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      modi = "combi,drun,run,ssh";
      combi-modi = "drun,ssh";
      show-icons = true;
      parse-known-hosts = false;
    };
  };
}
