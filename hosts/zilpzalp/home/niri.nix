{ lib, pkgs, ... }:

{
  programs.niri.settings = {
    layout.default-column-width = lib.mkForce { proportion = 1. / 2.; };
    spawn-at-startup = [
      { command = [ "element-desktop" ]; }
      { command = [ "thunderbird" ]; }
      { command = [ (lib.getExe pkgs.networkmanagerapplet) ]; }
    ];
  };
}
