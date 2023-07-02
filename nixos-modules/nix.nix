{ inputs, ... }:

{
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
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

  # disable channels
  nix.nixPath = [ ];
}
