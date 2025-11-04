{ ... }:

{
  programs.imv = {
    enable = true;

    settings = {
      options.overlay_font = "monospace:10";
      binds = {
        "<Shift+K>" = "prev";
        "<Shift+J>" = "next";

        "o" = "";
        "i" = "overlay";
        "d" = "";
        "<plus>" = "zoom 1";
        "<minus>" = "zoom -1";
        "<Shift+R>" = "rotate by 90";
      };
    };
  };
}
