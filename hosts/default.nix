{ lib, inputs }:

builtins.readDir ./.
|> lib.filterAttrs (name: type: type == "directory")
|> lib.mapAttrs (
  name: _:
  lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      myLib = import ../lib {
        inherit lib;
        inherit (inputs) nix-colorizer;
      };
    };
    modules = [
      ./${name}
      ../nixos-modules
      ../secrets
      { networking.hostName = name; }
    ];
  }
)
