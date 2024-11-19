{ osConfig, pkgs, inputs, ... }:

let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = let
    colorschemes = {
      gruvbox-material-dark = {
        theme = spicePkgs.themes.onepunch;
        colorScheme = "dark";
      };

      catppuccin-macchiato = {
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "macchiato";
      };

      catppuccin-frappe = {
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "frappe";
      };
    };
  in {
    enable = true;

    inherit (colorschemes.${osConfig.my.desktop.colorscheme}) theme colorScheme;

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      keyboardShortcut
      shuffle
      volumePercentage
    ];
  };
}
