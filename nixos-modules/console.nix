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

  services.getty.helpLine = lib.mkForce "";
}
