{ inputs, pkgs, ... }:

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

  nixpkgs.overlays = [
    (inputs.self.overlays.sway)
    (inputs.self.overlays.noise-repellent)
  ];

  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  # disable channels
  nix.nixPath = [];
}
