{ nixpkgs }:

{
  x86_64-linux = let pkgs = nixpkgs.legacyPackages."x86_64-linux";
  in {
    rust-cpp = import ./rust-cpp.nix { inherit pkgs; };
    js = import ./js.nix { inherit pkgs; };
    deno = import ./deno.nix { inherit pkgs; };
    python = import ./python.nix { inherit pkgs; };
  };
}
