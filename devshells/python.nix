{ pkgs, ... }:

pkgs.mkShell {
  name = "python";
  packages = with pkgs; [
    python310
    python310Packages.pip
    nodePackages.pyright
  ];
  shellHook = "exec zsh";
}
