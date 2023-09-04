{ nixpkgs }:

{
  x86_64-linux = let pkgs = nixpkgs.legacyPackages."x86_64-linux";
  in {
    rust-cpp = import ./devshells/rust-cpp.nix { inherit pkgs; };
    js = import ./devshells/js.nix { inherit pkgs; };
    deno = import ./devshells/deno.nix { inherit pkgs; };
    python = import ./devshells/python.nix { inherit pkgs; };
  };
}
