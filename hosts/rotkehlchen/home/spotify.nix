{ pkgs, inputs, ... }:

let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.onepunch;
    colorScheme = "dark";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      keyboardShortcut
      shuffle
      volumePercentage
    ];
  };
}
