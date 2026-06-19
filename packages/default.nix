{ nixpkgs, nixpkgs-unstable }:

{
  x86_64-linux =
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        # allowUnfree needed for vimPlugins.barbar-nvim
        config.allowUnfree = true;
      };
      callPackage = pkgs.callPackage;
    in
    {
      einkaufszettel = callPackage ./einkaufszettel.nix { };
      geoblock = callPackage ./geoblock { };
      gruvbox-material-gtk = callPackage ./gruvbox-material-gtk.nix { };
      improglycerin = callPackage ./improglycerin.nix { };
      improtheater-frankfurt = callPackage ./improtheater-frankfurt.nix { };
      lepton-firefox-theme = callPackage ./lepton-firefox-theme.nix { };
      lyrax-cursors = callPackage ./lyrax-cursors.nix { };
      neovim = callPackage ./neovim { };
      playerctl-current = callPackage ./playerctl-current { };
      xdg-open = callPackage ./xdg-open { };
    };

  aarch64-linux =
    let
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };
      callPackage = pkgs.callPackage;
    in
    {
      geoblock = callPackage ./geoblock { };
      improglycerin = callPackage ./improglycerin.nix { };
      improtheater-frankfurt = callPackage ./improtheater-frankfurt.nix { };
      neovim = callPackage ./neovim { };
    };
}
