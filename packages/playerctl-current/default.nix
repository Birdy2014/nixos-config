{ writeShellApplication, playerctl }:

writeShellApplication {
  name = "playerctl-current";
  runtimeInputs = [ playerctl ];
  text = builtins.readFile ./playerctl-current.sh;
}
