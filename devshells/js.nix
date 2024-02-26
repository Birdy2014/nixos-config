{ pkgs, ... }:

pkgs.mkShell {
  name = "js";
  packages = with pkgs; [ nodejs_20 nodePackages.typescript-language-server ];
}
