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
    nixosConfigurations = {
      rotkehlchen = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/rotkehlchen/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.moritz = import ./hosts/rotkehlchen/home.nix;
          }
        ];
      };
    };

    packages.x86_64-linux =
      let
        callPackage = nixpkgs.legacyPackages.x86_64-linux.callPackage;
      in
        {
          gruvbox-kvantum-themes = callPackage ./packages/gruvbox-kvantum-themes.nix {};
          gruvbox-material-gtk = callPackage ./packages/gruvbox-material-gtk.nix {};
          lyrax-cursors = callPackage ./packages/lyrax-cursors.nix {};
        };

    overlays.sway = import ./overlays/sway;

    devShells.x86_64-linux =
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in
        {
          rust-cpp = import ./devshells/rust-cpp.nix { inherit pkgs; };
          js = import ./devshells/js.nix { inherit pkgs; };
        };
  };
}
