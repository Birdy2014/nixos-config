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

    gtk4.extraCss = ''
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

      /* Remove close button */
      windowcontrols * {
        -gtk-icon-size: 0;
        opacity: 0;
        min-width: 0;
        min-height: 0;
        padding: 0;
        margin: 0;
      }

      /* Remove rounded borders */
      .solid-csd, .csd {
        border-radius: 0;
        border-style: none;
        box-shadow: none;
      }

      /* Remove title text in csd */
      headerbar .title {
        opacity: 0;
      }
    '';
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
  };
}
