{ pkgs, ... }:

pkgs.mkShell.override { stdenv = pkgs.clang16Stdenv; } rec {
  name = "rust-cpp";
  packages = with pkgs; [
    perf-tools
    hotspot
  ];
  buildInputs = with pkgs; [
    cargo
    rustc
    rustfmt
    clippy
    rust-analyzer

    cmake
    gnumake
    ninja
    ccache

    pkg-config
    fontconfig
    wayland
    wayland-protocols
    xorg.libX11
    libglvnd
    libxkbcommon
    xorg.libXcursor
    xorg.libXext
    xorg.libXrandr
    xorg.libXi
    xorg.libXinerama

    libGL
    vulkan-headers
    vulkan-loader
    vulkan-tools

    assimp
    libffi
  ];
  NIX_HARDENING_ENABLE = "";
  NIX_ENFORCE_PURITY = 0;
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  RUST_BACKTRACE = 1;
  LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath buildInputs;
  shellHook = "exec zsh";
}
