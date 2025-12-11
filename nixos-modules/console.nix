{ lib, pkgs, ... }:

{
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
    useXkbConfig = true;
    earlySetup = true;
  };

  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
    options = "caps:escape";
  };

  services.getty.helpLine = lib.mkForce "";
}
