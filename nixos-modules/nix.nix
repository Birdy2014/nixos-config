{ inputs, ... }:

{
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    keep-derivations = true;
    keep-outputs = true;
    flake-registry = "";
    fallback = true;
  };

  nix.gc = {
    automatic = true;
    dates = "monthly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.nur.overlay
    inputs.self.overlays.imv
    inputs.self.overlays.lf
    inputs.self.overlays.swayidle
  ];

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    unstable.flake = inputs.nixpkgs-unstable;
    system.flake = inputs.self;
  };
}
