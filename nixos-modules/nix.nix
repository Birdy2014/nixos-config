{ config, inputs, lib, pkgs, ... }:

{
  nix.settings = {
    allowed-users = [ "root" "@wheel" ];
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    keep-derivations = true;
    keep-outputs = true;
    flake-registry = "";
    fallback = true;
  };

  # Makes system derivation depend on the flake input sources.
  # This prevents them being deleted by gc, which is necessary
  # to be able to rebuild the system while offline.
  environment.etc.flake-inputs.source = pkgs.runCommand "flake-inputs" { } ''
    mkdir $out
    ${lib.concatLines
    (lib.mapAttrsToList (name: input: "ln -s ${input} $out/${name}") inputs)}
  '';

  nix.gc = {
    automatic = true;
    dates = "monthly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.self.overlays.blocky
    inputs.self.overlays.imv
    inputs.self.overlays.lf
    inputs.self.overlays.swayidle
    inputs.self.overlays.spicetify-cli
  ];

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    unstable.flake = inputs.nixpkgs-unstable;
    system.flake = inputs.self;
  };

  system.tools.nixos-option.enable = false;

  _module.args = let inherit (config.nixpkgs.hostPlatform) system;
  in {
    pkgsSelf = inputs.self.packages.${system};
    pkgsUnstable = import inputs.nixpkgs-unstable {
      system = system;
      config.allowUnfree = true;
    };
  };
}
