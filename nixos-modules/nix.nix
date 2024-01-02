{ inputs, ... }:

{
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    keep-derivations = true;
    keep-outputs = true;
    flake-registry = "";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;

  # This is obsidian's fault again.
  # Remove once https://github.com/NixOS/nixpkgs/issues/273611 has been resolved.
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  nixpkgs.overlays =
    [ inputs.nur.overlay inputs.self.overlays.sway inputs.self.overlays.f3d ];

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    system.flake = inputs.self;
  };

  # legacy nix channels
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
}
