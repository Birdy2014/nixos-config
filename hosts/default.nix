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
