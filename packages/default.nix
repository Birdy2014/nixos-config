{ nixpkgs, nixpkgs-unstable }:

{
  x86_64-linux =
    let
      callPackage = nixpkgs.legacyPackages.x86_64-linux.callPackage;
    in
    {
      einkaufszettel = callPackage ./einkaufszettel.nix { };
      gruvbox-material-gtk = callPackage ./gruvbox-material-gtk.nix { };
      improtheater-frankfurt = callPackage ./improtheater-frankfurt.nix { };
      lepton-firefox-theme = callPackage ./lepton-firefox-theme.nix { };
      lyrax-cursors = callPackage ./lyrax-cursors.nix { };
      mpv-thumbfast-vanilla-osc = callPackage ./mpv-thumbfast-vanilla-osc.nix { };
      neovim = callPackage ./neovim { };
      playerctl-current = callPackage ./playerctl-current { };
      xdg-open = callPackage ./xdg-open { };
    };

  aarch64-linux =
    let
      callPackage = nixpkgs.legacyPackages.aarch64-linux.callPackage;
    in
    {
      improtheater-frankfurt = callPackage ./improtheater-frankfurt.nix { };
      neovim = callPackage ./neovim { };
    };
}
