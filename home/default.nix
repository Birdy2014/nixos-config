{ ... }:

{
  imports = [
    ./btop.nix
    ./dunst.nix
    ./git.nix
    ./gpg.nix
    ./kitty.nix
    ./rofi
    ./spotify.nix
    ./sway.nix
    ./themes.nix
    ./waybar
    ./xdg.nix
    ./zsh.nix
  ];

  targets.genericLinux.enable = true;
}