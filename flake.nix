{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colorizer.url = "github:nutsalhan87/nix-colorizer/v0.2";

    rycee-nur-expressions = {
      url = "gitlab:rycee/nur-expressions";
      flake = false;
    };
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
