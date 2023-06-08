{ ... }:

{
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.xserver = {
    layout = "de";
    xkbOptions = "caps:escape";
  };
}
