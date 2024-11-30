{ pkgs, ... }:

pkgs.mkShell {
  name = "js";
  packages = with pkgs; [ nodejs_20 typescript-language-server ];
}
