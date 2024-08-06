{ lib, inputs }:

let
  hosts = [
    {
      name = "rotkehlchen";
      system = "x86_64-linux";
    }
    {
      name = "zilpzalp";
      system = "x86_64-linux";
    }
    {
      name = "singdrossel";
      system = "x86_64-linux";
    }
    {
      name = "seidenschwanz";
      system = "x86_64-linux";
    }
    {
      name = "buntspecht";
      system = "aarch64-linux";
    }
  ];
in (builtins.listToAttrs (map ({ name, system }: {
  name = name;
  value = lib.nixosSystem {
    system = system;
    specialArgs = {
      inherit inputs;
      myLib = import ../lib lib;
      pkgsSelf = inputs.self.packages.${system};
      pkgsUnstable = inputs.nixpkgs-unstable.legacyPackages.${system};
    };
    modules =
      [ ./${name} ../nixos-modules ../secrets { networking.hostName = name; } ];
  };
}) hosts))
