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
    playerctl-current = import ./playerctl-current { inherit pkgs; };
    xdg-open = callPackage ./xdg-open { };
  };
}
