{ lib, inputs, pkgs, config, ... }:

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
      "smb://moritz@seidenschwanz.mvogel.dev/ seidenschwanz.mvogel.dev"
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

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";

    # Remove close button in GTK CSD titlebar
    "org/gnome/desktop/wm/preferences".button-layout = "appmenu";

    "org/gtk/settings/file-chooser".sort-directories-first = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    platformTheme.package = with pkgs.kdePackages; [
      plasma-integration
      plasma-integration.qt5
      qtwayland # Needed for qt6 under wayland
      qtsvg # Needed for qt6 to render icons

      # QTQuick and Kirigami stuff
      qqc2-breeze-style
      qqc2-desktop-style
      libplasma
    ];
    style.package = [ pkgs.kdePackages.breeze pkgs.kdePackages.breeze.qt5 ];
  };

  xdg.configFile = {
    "kdeglobals".text = let
      hexNumbers =
        lib.genAttrs (lib.genList (x: toString x) 10) (x: lib.toInt x) // {
          "a" = 10;
          "b" = 11;
          "c" = 12;
          "d" = 13;
          "e" = 14;
          "f" = 15;
        };
      hexToDec = hex:
        let len = lib.stringLength hex;
        in if len == 0 then
          0
        else
          (hexNumbers.${lib.toLower (lib.substring (len - 1) 1 hex)} + 16
            * hexToDec (lib.substring 0 (len - 1) hex));
      qtColor = hex:
        lib.concatStringsSep ","
        (map (x: toString (hexToDec (lib.substring x 2 hex))) [ 1 3 5 ]);

      # TODO: Color naming; generalize colors together with gtk colors
      color1 = "#3C3836";
      color2 = "#282828";
      color3 = "#689D6A";
      color4 = "#83A598";
      color5 = "#8EC07C";
      color6 = "#377375";
      color7 = "#B8BB26";
      color8 = "#DA4453";
      color9 = "#F67400";
      color10 = "#EBDBB2";
      color11 = "#27AE60";
      color12 = "#7F8C8D";
      color13 = "#FCFCFC";
      color14 = "#FDBC4B";
      color15 = "#BDC3C7";
      # Based on https://store.kde.org/p/1327717/
    in ''
      [ColorEffects:Disabled]
      ChangeSelectionColor=
      Color=56,56,56
      ColorAmount=0
      ColorEffect=0
      ContrastAmount=0.65000000000000002
      ContrastEffect=1
      Enable=
      IntensityAmount=0.10000000000000001
      IntensityEffect=2

      [ColorEffects:Inactive]
      ChangeSelectionColor=true
      Color=112,111,110
      ColorAmount=0.025000000000000001
      ColorEffect=2
      ContrastAmount=0.10000000000000001
      ContrastEffect=2
      Enable=true
      IntensityAmount=0
      IntensityEffect=0

      [Colors:Button]
      BackgroundAlternate=${qtColor color1}
      BackgroundNormal=${qtColor color2}
      DecorationFocus=${qtColor color3}
      DecorationHover=${qtColor color4}
      ForegroundActive=${qtColor color5}
      ForegroundInactive=${qtColor color6}
      ForegroundLink=${qtColor color7}
      ForegroundNegative=${qtColor color8}
      ForegroundNeutral=${qtColor color9}
      ForegroundNormal=${qtColor color10}
      ForegroundPositive=${qtColor color11}
      ForegroundVisited=${qtColor color12}

      [Colors:Selection]
      BackgroundAlternate=${qtColor color5}
      BackgroundNormal=${qtColor color3}
      DecorationFocus=${qtColor color3}
      DecorationHover=${qtColor color4}
      ForegroundActive=${qtColor color13}
      ForegroundInactive=${qtColor color10}
      ForegroundLink=${qtColor color14}
      ForegroundNegative=${qtColor color8}
      ForegroundNeutral=${qtColor color9}
      ForegroundNormal=${qtColor color10}
      ForegroundPositive=${qtColor color11}
      ForegroundVisited=${qtColor color15}

      [Colors:Tooltip]
      BackgroundAlternate=${qtColor color1}
      BackgroundNormal=${qtColor color2}
      DecorationFocus=${qtColor color3}
      DecorationHover=${qtColor color4}
      ForegroundActive=${qtColor color7}
      ForegroundInactive=${qtColor color6}
      ForegroundLink=${qtColor color5}
      ForegroundNegative=${qtColor color8}
      ForegroundNeutral=${qtColor color9}
      ForegroundNormal=${qtColor color10}
      ForegroundPositive=${qtColor color11}
      ForegroundVisited=${qtColor color12}

      [Colors:View]
      BackgroundAlternate=${qtColor color1}
      BackgroundNormal=${qtColor color2}
      DecorationFocus=${qtColor color3}
      DecorationHover=${qtColor color4}
      ForegroundActive=${qtColor color7}
      ForegroundInactive=${qtColor color6}
      ForegroundLink=${qtColor color5}
      ForegroundNegative=${qtColor color8}
      ForegroundNeutral=${qtColor color9}
      ForegroundNormal=${qtColor color10}
      ForegroundPositive=${qtColor color11}
      ForegroundVisited=${qtColor color12}

      [Colors:Window]
      BackgroundAlternate=${qtColor color1}
      BackgroundNormal=${qtColor color2}
      DecorationFocus=${qtColor color3}
      DecorationHover=${qtColor color4}
      ForegroundActive=${qtColor color7}
      ForegroundInactive=${qtColor color6}
      ForegroundLink=${qtColor color5}
      ForegroundNegative=${qtColor color8}
      ForegroundNeutral=${qtColor color9}
      ForegroundNormal=${qtColor color10}
      ForegroundPositive=${qtColor color11}
      ForegroundVisited=${qtColor color12}

      [General]
      ColorScheme=GruvboxColors
      TerminalApplication=kitty
      XftHintStyle=hintslight
      XftSubPixel=none
      fixed=Monospace,10,-1,5,50,0,0,0,0,0
      font=Sans Serif,10,-1,5,50,0,0,0,0,0
      menuFont=Sans Serif,10,-1,5,50,0,0,0,0,0
      smallestReadableFont=Sans Serif,8,-1,5,50,0,0,0,0,0
      toolBarFont=Sans Serif,10,-1,5,50,0,0,0,0,0

      [Icons]
      Theme=${config.gtk.iconTheme.name}

      [KDE]
      LookAndFeelPackage=org.kde.breezedark.desktop
      ShowDeleteCommand=false

      [KFileDialog Settings]
      Allow Expansion=false
      Automatically select filename extension=true
      Breadcrumb Navigation=true
      Decoration position=2
      LocationCombo Completionmode=5
      PathCombo Completionmode=5
      Show Bookmarks=false
      Show Full Path=false
      Show Inline Previews=true
      Show Preview=false
      Show Speedbar=true
      Show hidden files=false
      Sort by=Name
      Sort directories first=true
      Sort hidden files last=false
      Sort reversed=false
      Speedbar Width=144
      View Style=DetailTree

      [KShortcutsDialog Settings]
      Dialog Size=600,480

      [PreviewSettings]
      MaximumRemoteSize=0

      [WM]
      activeBackground=39,39,39
      activeBlend=${qtColor color10}
      activeFont=Sans Serif,10,-1,5,50,0,0,0,0,0
      activeForeground=${qtColor color10}
      inactiveBackground=${qtColor color2}
      inactiveBlend=${qtColor color1}
      inactiveForeground=204,190,155
    '';
  };
}
