{ lib, ... }:

{
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
    options = "caps:escape";
  };

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        capslock = "esc";
        rightmeta = "f13";

        # The menu key is "compose", not "menu"
        compose = "f13";

        # Upper mouse side button
        mouse2 = "layer(meta)";
      };
    };
  };

  services.getty.helpLine = lib.mkForce "";
}
