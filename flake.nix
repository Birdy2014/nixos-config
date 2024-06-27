{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Mealie 1.9.0 is broken: https://github.com/NixOS/nixpkgs/issues/321623
    nixpkgs-mealie.url =
      "github:NixOS/nixpkgs/c00d587b1a1afbf200b1d8f0b0e4ba9deb1c7f0e";

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
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
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
