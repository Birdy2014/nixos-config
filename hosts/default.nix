{ lib, inputs }:

let
  hosts =
    [ "rotkehlchen" "zilpzalp" "singdrossel" "seidenschwanz" "buntspecht" ];
in (builtins.listToAttrs (map (name: {
  name = name;
  value = lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      myLib = import ../lib {
        inherit lib;
        inherit (inputs) nix-colorizer;
      };
    };
    modules =
      [ ./${name} ../nixos-modules ../secrets { networking.hostName = name; } ];
  };
}) hosts))
