{ pkgs }:

(import ./cpp.nix { inherit pkgs; }).overrideAttrs (final: prev: {
  name = "rust";
  packages = prev.packages
    ++ (with pkgs; [ cargo rustc rustfmt clippy rust-analyzer ]);
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  RUST_BACKTRACE = 1;
})
