{ pkgs, ... }:

pkgs.mkShell {
  name = "js";
  packages = with pkgs; [ nodejs_24 typescript-language-server ];
}
