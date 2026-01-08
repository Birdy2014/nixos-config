{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  options.my.nix.useLocalCache = {
    enable = lib.mkEnableOption "nix cache hosted on seidenschwanz";
    prefer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Prefer cache on seidenschwanz to cache.nixos.org";
    };
  };

  config = {
    nix.settings = {
      allowed-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      keep-derivations = true;
      keep-outputs = true;
      flake-registry = "";
      fallback = true;
      trusted-public-keys = [
        "cache.seidenschwanz.mvogel.dev:TAQQzegeSxaE7CvWMyPI70yoZp/M6JaHhj7zQez4Aqo="
      ];
      substituters =
        let
          order = if config.my.nix.useLocalCache.prefer then 1000 else 1600;
        in
        lib.mkIf config.my.nix.useLocalCache.enable (
          lib.mkOrder order [
            "https://cache.seidenschwanz.mvogel.dev"
          ]
        );
    };

    # Makes system derivation depend on the flake input sources.
    # This prevents them being deleted by gc, which is necessary
    # to be able to rebuild the system while offline.
    environment.etc.flake-inputs.source = pkgs.runCommand "flake-inputs" { } ''
      mkdir $out
      ${lib.concatLines (lib.mapAttrsToList (name: input: "ln -s ${input} $out/${name}") inputs)}
    '';

    nix.gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };

    nixpkgs.config.allowUnfree = true;

    nixpkgs.overlays = [ inputs.self.overlays.default ];

    nix.registry = {
      nixpkgs.flake = inputs.nixpkgs;
      unstable.flake = inputs.nixpkgs-unstable;
      system.flake = inputs.self;
    };

    system.tools.nixos-option.enable = false;

    _module.args =
      let
        inherit (config.nixpkgs.hostPlatform) system;
      in
      {
        pkgsSelf = inputs.self.packages.${system};
        pkgsUnstable = import inputs.nixpkgs-unstable {
          system = system;
          config.allowUnfree = true;
        };
      };
  };
}
