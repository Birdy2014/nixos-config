{ pkgs }:

pkgs.mkShell.override { stdenv = pkgs.clang19Stdenv; } {
  name = "cpp";
  packages = with pkgs; [
    cmake
    meson
    gnumake
    ninja
  ];
  NIX_HARDENING_ENABLE = "";
  NIX_ENFORCE_PURITY = 0;
}
