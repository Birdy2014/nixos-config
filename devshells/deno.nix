{ pkgs, ... }:

pkgs.mkShell {
  name = "deno";
  packages = with pkgs; [ deno ];
  shellHook = "exec zsh";
}
