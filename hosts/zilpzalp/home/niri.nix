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
      window-rules = [
        {
          matches = [ { app-id = "^element$"; } ];
          open-on-workspace = "05";
          open-maximized = true;
          open-focused = false;
        }
      ];
    };
  };
}
