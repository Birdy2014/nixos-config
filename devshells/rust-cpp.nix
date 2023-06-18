# FIXME: GUI application compile but don't run
# FIXME: clangd can't find headers

{ pkgs, ... }:

pkgs.mkShell.override { stdenv = pkgs.clang16Stdenv; } {
  name = "rust-cpp";
  packages = [
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

    # Needed?
    #vulkan-headers
    vulkan-loader
    #vulkan-tools
    udev

    assimp
  ];
  NIX_HARDENING_ENABLE = "";
  NIX_ENFORCE_PURITY = 0;
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  RUST_BACKTRACE = 1;
  shellHook = "exec zsh";
}
