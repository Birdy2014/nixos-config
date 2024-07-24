{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = ""; # Only used for tests
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    nix-colorizer.url = "github:nutsalhan87/nix-colorizer/v0.2";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    nixosConfigurations = import ./hosts {
      lib = nixpkgs.lib;
      inherit inputs;
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-classic;

    packages = import ./packages {
      inherit nixpkgs;
      inherit nixpkgs-unstable;
    };
    overlays = import ./overlays;
    devShells = import ./devshells { inherit nixpkgs; };
  };
}
