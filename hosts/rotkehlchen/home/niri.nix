{ config, lib, ... }:

{
  config = lib.mkIf config.programs.niri.enable {
    programs.niri.settings.spawn-at-startup = [
      { command = [ "element-desktop" ]; }
      { command = [ "vesktop" ]; }
      { command = [ "thunderbird" ]; }
    ];
  };
}
