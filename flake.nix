{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = import ./hosts {
      lib = nixpkgs.lib;
      inherit inputs;
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

    packages = import ./packages { inherit nixpkgs; };
    overlays = import ./overlays;
    devShells = import ./devshells { inherit nixpkgs; };
  };
}
