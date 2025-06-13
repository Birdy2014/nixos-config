{ nixpkgs }:

{
  x86_64-linux =
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in
    {
      cpp = import ./cpp.nix { inherit pkgs; };
      js = import ./js.nix { inherit pkgs; };
      python = import ./python.nix { inherit pkgs; };
      rust = import ./rust.nix { inherit pkgs; };
    };
}
