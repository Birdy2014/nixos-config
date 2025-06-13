{ config, lib, ... }:

{
  programs.foot = {
    enable = true;
    settings =
      let
        color = lib.removePrefix "#";
      in
      {
        main = {
          font = "monospace:size=10:weight=medium";
          font-bold = "monospace:size=10:weight=bold";
          initial-window-size-pixels = "720x480";
          resize-by-cells = false;
          resize-keep-grid = false;
        };
        cursor.color = with config.my.theme; "${color background-secondary} ${color text}";
        colors = with config.my.theme; {
          background = color background-secondary;
          foreground = color text;

          regular0 = color black;
          regular1 = color red;
          regular2 = color green;
          regular3 = color yellow;
          regular4 = color blue;
          regular5 = color magenta;
          regular6 = color cyan;
          regular7 = color white;

          bright0 = color light-black;
          bright1 = color light-red;
          bright2 = color light-green;
          bright3 = color light-yellow;
          bright4 = color light-blue;
          bright5 = color light-magenta;
          bright6 = color light-cyan;
          bright7 = color light-white;
        };
        key-bindings = {
          clipboard-copy = "Control+Shift+c";
          clipboard-paste = "Control+Shift+v";
          primary-paste = "Control+Shift+y";
          font-increase = "Control+Shift+Page_Up";
          font-decrease = "Control+Shift+Page_Down";
        };
      };
  };
}
