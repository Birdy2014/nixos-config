{ pkgs }:

pkgs.mkShell {
  name = "nixos-config";
  packages = with pkgs; [
    nixfmt
  ];
}
