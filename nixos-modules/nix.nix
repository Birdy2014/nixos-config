{ inputs, ... }:

{
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" "repl-flake" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [ inputs.nur.overlay (inputs.self.overlays.sway) ];

  # FIXME: Remove this once it is no longer necessary
  nixpkgs.config.permittedInsecurePackages = [ "electron-24.8.6" ];

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    system.flake = inputs.self;
  };

  # legacy nix channels
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
}
