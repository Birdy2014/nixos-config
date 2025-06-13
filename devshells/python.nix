{ pkgs, ... }:

pkgs.mkShell {
  name = "python";
  packages = with pkgs; [
    python312
    python312Packages.pip
    pyright
  ];
}
