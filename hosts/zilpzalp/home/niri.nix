{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.programs.niri.enable {
    programs.niri.settings = {
      spawn-at-startup = [
        { command = [ "element-desktop" ]; }
        { command = [ "thunderbird" ]; }
        { command = [ (lib.getExe pkgs.networkmanagerapplet) ]; }
      ];
    };
  };
}
