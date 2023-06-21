{ ... }:

{
  imports = [
    ../../home-modules/xdg.nix
    ../../home-modules/gpg.nix
    ../../home-modules/spotify.nix
  ];

  home.stateVersion = "23.05";
}
