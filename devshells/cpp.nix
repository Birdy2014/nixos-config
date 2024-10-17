{ pkgs }:

pkgs.mkShell.override { stdenv = pkgs.clang17Stdenv; } rec {
  name = "cpp";
  packages = with pkgs; [ gdb perf-tools hotspot ];
  nativeBuildInputs = with pkgs; [
    cmake
    meson
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
  ];
  NIX_HARDENING_ENABLE = "";
  NIX_ENFORCE_PURITY = 0;
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
}
