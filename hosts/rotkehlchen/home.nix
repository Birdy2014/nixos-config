{ ... }:

{
  imports = [
    ../../home-modules/common.nix
    ../../home-modules/xdg.nix
    ../../home-modules/gpg.nix
    ../../home-modules/spotify.nix
    ../../home-modules/themes.nix
    ../../home-modules/zsh.nix
    ../../home-modules/kitty.nix
    ../../home-modules/dunst.nix
    ../../home-modules/rofi
    ../../home-modules/waybar
  ];

  home.stateVersion = "23.05";
}
