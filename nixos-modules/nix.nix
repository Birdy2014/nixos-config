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

  nixpkgs.overlays = [ (inputs.self.overlays.sway) ];

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    system.flake = inputs.self;
  };

  # legacy nix channels
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
}
