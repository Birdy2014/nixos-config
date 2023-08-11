{ lib, inputs }:

let
  nixosSystem = hostname:
    lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./${hostname}/configuration.nix ];
    };
in {
  rotkehlchen = nixosSystem "rotkehlchen";
  zilpzalp = nixosSystem "zilpzalp";
}
