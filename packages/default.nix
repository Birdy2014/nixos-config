{ nixpkgs }:

{
  x86_64-linux = let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    callPackage = pkgs.callPackage;
  in {
    gruvbox-kvantum-themes = callPackage ./gruvbox-kvantum-themes.nix { };
    gruvbox-material-gtk = callPackage ./gruvbox-material-gtk.nix { };
    lepton-firefox-theme = callPackage ./lepton-firefox-theme.nix { };
    lyrax-cursors = callPackage ./lyrax-cursors.nix { };
    mpv-thumbfast-vanilla-osc = callPackage ./mpv-thumbfast-vanilla-osc.nix { };
    neovim = callPackage ./neovim { };
    playerctl-current = callPackage ./playerctl-current { };
    xdg-open = callPackage ./xdg-open { };
  };

  aarch64-linux = let
    pkgs = nixpkgs.legacyPackages.aarch64-linux;
    callPackage = pkgs.callPackage;
  in { neovim = callPackage ./neovim { }; };
}
