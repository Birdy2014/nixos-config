{ ... }:

{
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.xserver = {
    layout = "de";
    xkbVariant = "nodeadkeys";
    xkbOptions = "caps:escape";
  };
}
