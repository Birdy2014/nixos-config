{ lib, inputs }:

let hosts = [ "rotkehlchen" "zilpzalp" "live-iso" ];
in (builtins.listToAttrs (map (host: {
  name = host;
  value = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      ./${host}/configuration.nix
      ../nixos-modules
      { networking.hostName = host; }
    ];
  };
}) hosts))
