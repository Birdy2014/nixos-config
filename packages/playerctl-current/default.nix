{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "playerctl-current";
  runtimeInputs = [ pkgs.playerctl ];
  text = builtins.readFile ./playerctl-current.sh;
}
