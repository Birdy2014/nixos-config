{ inputs, pkgs, config, ... }:

{
  imports = [ ./xdg.nix ];

  home.pointerCursor = {
    name = "LyraX-cursors";
    size = 24;
    package = inputs.self.packages.${pkgs.system}.lyrax-cursors;
    gtk.enable = true;
  };

  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Gruvbox-Material-Dark";
      package = inputs.self.packages.${pkgs.system}.gruvbox-material-gtk;
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
      "smb://seidenschwanz.mvogel.dev/ seidenschwanz.mvogel.dev"
    ];

    gtk3.extraCss = config.gtk.gtk4.extraCss;

    # Reference: https://gnome.pages.gitlab.gnome.org/libadwaita/doc/main/named-colors.html
    gtk4.extraCss = ''
      /* Accent */
      @define-color accent_color #e78a4e;
      @define-color accent_bg_color #a96b2c;
      @define-color accent_fg_color #000000;

      /* Destructive */
      @define-color destructive_color #ff7b63;
      @define-color destructive_bg_color #c01c28;
      @define-color destructive_fg_color #ffffff;

      /* Success */
      @define-color success_color #a9b665;
      @define-color success_bg_color #26a269;
      @define-color success_fg_color #ffffff;

      /* Warning */
      @define-color warning_color #d8a657;
      @define-color warning_bg_color #cd9309;
      @define-color warning_fg_color rgba(0, 0, 0, 0.8);

      /* Error */
      @define-color error_color #ea6962;
      @define-color error_bg_color #e33e35;
      @define-color error_fg_color #ffffff;

      /* Window */
      @define-color window_bg_color #282828;
      @define-color window_fg_color #dbc8a9;

      /* View */
      @define-color view_bg_color #323232;
      @define-color view_fg_color @window_fg_color;

      /* Headerbar */
      @define-color headerbar_bg_color #32302f;
      @define-color headerbar_fg_color @window_fg_color;
      @define-color headerbar_border_color #D4BE98;
      @define-color headerbar_backdrop_color #282625;
      @define-color headerbar_shade_color rgba(0, 0, 0, 0.36);

      /* Card */
      @define-color card_bg_color @dialog_bg_color;
      @define-color card_fg_color @window_fg_color;
      @define-color card_shade_color rgba(0, 0, 0, 0.36);

      /* Dialog */
      @define-color dialog_bg_color #383838;
      @define-color dialog_fg_color #ffffff;

      /* Popover */
      @define-color popover_bg_color @dialog_bg_color;
      @define-color popover_fg_color #ffffff;

      /* Misc */
      @define-color shade_color rgba(0, 0, 0, 0.36);
      @define-color scrollbar_outline_color rgba(0, 0, 0, 0.5);

      /* Sidebar */
      @define-color sidebar_bg_color @window_bg_color;
      @define-color sidebar_fg_color @window_fg_color;
      @define-color sidebar_backdrop_color #2a2a2a;
      @define-color sidebar_shade_color rgba(0, 0, 0, 0.36);
      @define-color secondary_sidebar_bg_color #2a2a2a;
      @define-color secondary_sidebar_fg_color @sidebar_fg_color;
      @define-color secondary_sidebar_backdrop_color #272727;
      @define-color secondary_sidebar_shade_color @sidebar_shade_color;

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
      window.solid-csd, window.csd {
        border-radius: 0;
        border-style: none;
        box-shadow: none;
      }

      /* Remove title text in csd */
      headerbar .title {
        opacity: 0;
      }

      /* Tooltip */
      tooltip.background {
        background-color: rgba(50, 48, 47, 0.9);
        color: #ddc7a1;
      }

      tooltip > box {
        margin: -6px;
        min-height: 24px;
        padding: 4px 8px;
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

    "Kvantum/Gruvbox-Dark-Green".source = "${
        inputs.self.packages.${pkgs.system}.gruvbox-kvantum-themes
      }/share/Kvantum/Gruvbox-Dark-Green";
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
