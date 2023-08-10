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

    packages.x86_64-linux =
      let callPackage = nixpkgs.legacyPackages.x86_64-linux.callPackage;
      in {
        gruvbox-kvantum-themes =
          callPackage ./packages/gruvbox-kvantum-themes.nix { };
        gruvbox-material-gtk =
          callPackage ./packages/gruvbox-material-gtk.nix { };
        lyrax-cursors = callPackage ./packages/lyrax-cursors.nix { };
        xdg-open = callPackage ./packages/xdg-open { };
      };

    overlays.sway = import ./overlays/sway;

    devShells.x86_64-linux = let pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in {
      rust-cpp = import ./devshells/rust-cpp.nix { inherit pkgs; };
      js = import ./devshells/js.nix { inherit pkgs; };
      python = import ./devshells/python.nix { inherit pkgs; };
    };
  };
}
