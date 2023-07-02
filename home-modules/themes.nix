{ inputs, pkgs, config, ... }:

{
  imports = [ ./xdg.nix ];

  home.pointerCursor = {
    name = "LyraX-cursors";
    size = 24;
    package = inputs.self.packages.x86_64-linux.lyrax-cursors;
    gtk.enable = true;
  };

  gtk = {
    enable = true;

    theme = {
      name = "Gruvbox-Material-Dark";
      package = inputs.self.packages.x86_64-linux.gruvbox-material-gtk;
    };

    iconTheme = {
      name = "Gruvbox-Material-Dark";
      package = inputs.self.packages.x86_64-linux.gruvbox-material-gtk;
    };

    font = {
      name = "sans-serif";
      size = 10;
    };

    gtk3.bookmarks = [
      "file://${config.home.homeDirectory}/Documents"
      "file://${config.home.homeDirectory}/Downloads"
      "file://${config.home.homeDirectory}/Music"
      "file://${config.home.homeDirectory}/Pictures"
      "file://${config.home.homeDirectory}/Videos"
    ];
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "kvantum-dark";
      package = pkgs.libsForQt5.qtstyleplugin-kvantum;
    };
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Gruvbox-Dark-Green
    '';

    "Kvantum/Gruvbox-Dark-Green".source =
      "${inputs.self.packages.x86_64-linux.gruvbox-kvantum-themes}/share/Kvantum/Gruvbox-Dark-Green";

    "gtk-4.0/gtk.css".text = ''
      @define-color accent_color #d4be98;
      @define-color accent_bg_color #282828;
      @define-color accent_fg_color #d4be98;
      @define-color destructive_color #ff7b63;
      @define-color destructive_bg_color #c01c28;
      @define-color destructive_fg_color #ffffff;
      @define-color success_color #a9b665;
      @define-color success_bg_color #26a269;
      @define-color success_fg_color #ffffff;
      @define-color warning_color #d8a657;
      @define-color warning_bg_color #cd9309;
      @define-color warning_fg_color rgba(0, 0, 0, 0.8);
      @define-color error_color #ea6962;
      @define-color error_bg_color #e33e35;
      @define-color error_fg_color #ffffff;
      @define-color window_bg_color #282828;
      @define-color window_fg_color #dbc8a9;
      @define-color view_bg_color #1e1e1e;
      @define-color view_fg_color @window_fg_color;
      @define-color headerbar_bg_color #32302f;
      @define-color headerbar_fg_color @window_fg_color;
      @define-color headerbar_border_color #D4BE98;
      @define-color headerbar_backdrop_color #282625;
      @define-color headerbar_shade_color rgba(0, 0, 0, 0.36);
      @define-color card_bg_color rgba(255, 255, 255, 0.08);
      @define-color card_fg_color @window_fg_color;
      @define-color card_shade_color rgba(0, 0, 0, 0.36);
      @define-color dialog_bg_color #383838;
      @define-color dialog_fg_color #ffffff;
      @define-color popover_bg_color #383838;
      @define-color popover_fg_color #ffffff;
      @define-color shade_color rgba(0, 0, 0, 0.36);
      @define-color scrollbar_outline_color rgba(0, 0, 0, 0.5);
      @define-color blue_1 #99c1f1;
      @define-color blue_2 #62a0ea;
      @define-color blue_3 #3584e4;
      @define-color blue_4 #1c71d8;
      @define-color blue_5 #1a5fb4;
      @define-color green_1 #8ff0a4;
      @define-color green_2 #57e389;
      @define-color green_3 #33d17a;
      @define-color green_4 #2ec27e;
      @define-color green_5 #26a269;
      @define-color yellow_1 #f9f06b;
      @define-color yellow_2 #f8e45c;
      @define-color yellow_3 #f6d32d;
      @define-color yellow_4 #f5c211;
      @define-color yellow_5 #e5a50a;
      @define-color orange_1 #ffbe6f;
      @define-color orange_2 #ffa348;
      @define-color orange_3 #ff7800;
      @define-color orange_4 #e66100;
      @define-color orange_5 #c64600;
      @define-color red_1 #f66151;
      @define-color red_2 #ed333b;
      @define-color red_3 #e01b24;
      @define-color red_4 #c01c28;
      @define-color red_5 #a51d2d;
      @define-color purple_1 #dc8add;
      @define-color purple_2 #c061cb;
      @define-color purple_3 #9141ac;
      @define-color purple_4 #813d9c;
      @define-color purple_5 #613583;
      @define-color brown_1 #cdab8f;
      @define-color brown_2 #b5835a;
      @define-color brown_3 #986a44;
      @define-color brown_4 #865e3c;
      @define-color brown_5 #63452c;
      @define-color light_1 #ffffff;
      @define-color light_2 #f6f5f4;
      @define-color light_3 #deddda;
      @define-color light_4 #c0bfbc;
      @define-color light_5 #9a9996;
      @define-color dark_1 #77767b;
      @define-color dark_2 #5e5c64;
      @define-color dark_3 #3d3846;
      @define-color dark_4 #241f31;
      @define-color dark_5 #000000;
    '';
  };
}
