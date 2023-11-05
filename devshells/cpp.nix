{ pkgs }:

pkgs.mkShell.override { stdenv = pkgs.clang16Stdenv; } rec {
  name = "cpp";
  packages = with pkgs; [ gdb perf-tools hotspot ];
  nativeBuildInputs = with pkgs; [
    cmake
    gnumake
    ninja
    ccache

    pkg-config
  ];
  buildInputs = with pkgs; [
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
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
}
