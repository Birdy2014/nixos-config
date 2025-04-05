{ ... }:

{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "element-desktop" ]; }
    { command = [ "vesktop" ]; }
    { command = [ "thunderbird" ]; }
  ];
}
