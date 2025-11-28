{ nixpkgs, nixpkgs-unstable }:

{
  x86_64-linux =
    let
      callPackage = nixpkgs.legacyPackages.x86_64-linux.callPackage;
    in
    {
      einkaufszettel = callPackage ./einkaufszettel.nix { };
      gruvbox-material-gtk = callPackage ./gruvbox-material-gtk.nix { };
      improglycerin = callPackage ./improglycerin.nix { };
      improtheater-frankfurt = callPackage ./improtheater-frankfurt.nix { };
      imv = callPackage ./imv.nix { };
      lepton-firefox-theme = callPackage ./lepton-firefox-theme.nix { };
      lyrax-cursors = callPackage ./lyrax-cursors.nix { };
      mpv-thumbfast-vanilla-osc = callPackage ./mpv-thumbfast-vanilla-osc.nix { };
      neovim = callPackage ./neovim { };
      playerctl-current = callPackage ./playerctl-current { };
      wine-sandbox = callPackage ./wine-sandbox { };
      xdg-open = callPackage ./xdg-open { };
    };

  aarch64-linux =
    let
      callPackage = nixpkgs.legacyPackages.aarch64-linux.callPackage;
    in
    {
      improglycerin = callPackage ./improglycerin.nix { };
      improtheater-frankfurt = callPackage ./improtheater-frankfurt.nix { };
      neovim = callPackage ./neovim { };
    };
}
