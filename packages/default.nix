{ nixpkgs }:

{
  x86_64-linux =
    let callPackage = nixpkgs.legacyPackages.x86_64-linux.callPackage;
    in {
      gruvbox-kvantum-themes = callPackage ./gruvbox-kvantum-themes.nix { };
      gruvbox-material-gtk = callPackage ./gruvbox-material-gtk.nix { };
      lyrax-cursors = callPackage ./lyrax-cursors.nix { };
      xdg-open = callPackage ./xdg-open { };
    };
}
