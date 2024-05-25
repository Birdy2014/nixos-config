{ nixpkgs, nixpkgs-unstable }:

{
  x86_64-linux = let
    callPackage = nixpkgs.legacyPackages.x86_64-linux.callPackage;
    callPackageUnstable =
      nixpkgs-unstable.legacyPackages.x86_64-linux.callPackage;
  in {
    gruvbox-kvantum-themes = callPackage ./gruvbox-kvantum-themes.nix { };
    gruvbox-material-gtk = callPackage ./gruvbox-material-gtk.nix { };
    lepton-firefox-theme = callPackage ./lepton-firefox-theme.nix { };
    lyrax-cursors = callPackage ./lyrax-cursors.nix { };
    mpv-thumbfast-vanilla-osc = callPackage ./mpv-thumbfast-vanilla-osc.nix { };
    neovim = callPackageUnstable ./neovim { };
    playerctl-current = callPackage ./playerctl-current { };
    xdg-open = callPackage ./xdg-open { };
  };

  aarch64-linux = let
    callPackageUnstable =
      nixpkgs-unstable.legacyPackages.aarch64-linux.callPackage;
  in { neovim = callPackageUnstable ./neovim { }; };
}
