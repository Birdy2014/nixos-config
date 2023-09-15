{ pkgs, ... }:

pkgs.mkShell {
  name = "js";
  packages = with pkgs; [ nodejs_18 nodePackages.typescript-language-server ];
}
