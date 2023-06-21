{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{
  imports = [ inputs.spicetify-nix.homeManagerModule ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.Onepunch;
    colorScheme = "dark";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      keyboardShortcut
      shuffle
      volumePercentage
    ];
  };
}
