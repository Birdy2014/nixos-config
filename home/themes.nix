{ lib, myLib, pkgs, pkgsSelf, config, ... }:

{
  imports = [ ./xdg.nix ];

  options.my.theme = lib.genAttrs [
    "accent"
    "accent-text"
    "background-window"
    "background-view"
    "text"
    "text-inactive"
    "error"
    "headerbar-background"
    "headerbar-background-inactive"
    "black"
    "light-black"
    "red"
    "light-red"
    "green"
    "light-green"
    "yellow"
    "light-yellow"
    "blue"
    "light-blue"
    "magenta"
    "light-magenta"
    "cyan"
    "light-cyan"
    "white"
    "light-white"
  ] (name:
    lib.mkOption {
      type = lib.types.str;
      description = "color";
    });

  config = let
    cfg = config.my.theme;

    clampByte = x:
      if x < 0 then 0 else (if x > 255 then 255 else builtins.floor x);

    shade = color: factor:
      "#" + (lib.concatStrings (map (x:
        lib.fixedWidthString 2 "0" (myLib.decToHex
          (clampByte (myLib.hexToDec (lib.substring x 2 color) * factor)))) [
            1
            3
            5
          ]));

    accent-standalone = shade cfg.accent 1.5;

    background-alternate = shade cfg.background-view 1.2;
  in {
    home.pointerCursor = {
      name = "LyraX-cursors";
      size = 24;
      package = pkgsSelf.lyrax-cursors;
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
        package = pkgsSelf.gruvbox-material-gtk;
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

      # Reference: https://gnome.pages.gitlab.gnome.org/libadwaita/doc/main/css-variables.html
      gtk4.extraCss = ''
        /* Accent */
        @define-color accent_bg_color ${cfg.accent};
        @define-color accent_fg_color ${cfg.accent-text}; /* accent_fg_color apparently must be either black or white */
        @define-color accent_color ${accent-standalone};

        /* Destructive */
        @define-color destructive_color #ff7b63;
        @define-color destructive_bg_color #c01c28;
        @define-color destructive_fg_color ${cfg.text};

        /* Success */
        @define-color success_color #a9b665;
        @define-color success_bg_color #26a269;
        @define-color success_fg_color ${cfg.text};

        /* Warning */
        @define-color warning_color #d8a657;
        @define-color warning_bg_color #cd9309;
        @define-color warning_fg_color rgba(0, 0, 0, 0.8);

        /* Error */
        @define-color error_color ${cfg.error};
        @define-color error_bg_color #e33e35;
        @define-color error_fg_color ${cfg.text};

        /* Window */
        @define-color window_bg_color ${cfg.background-window};
        @define-color window_fg_color ${cfg.text};

        /* View */
        @define-color view_bg_color ${cfg.background-view};
        @define-color view_fg_color ${cfg.text};

        /* Headerbar */
        @define-color headerbar_bg_color ${cfg.headerbar-background};
        @define-color headerbar_fg_color ${cfg.text};
        @define-color headerbar_border_color #D4BE98;
        @define-color headerbar_backdrop_color ${cfg.headerbar-background-inactive};
        @define-color headerbar_shade_color rgba(0, 0, 0, 0.36);

        /* Card */
        @define-color card_bg_color @dialog_bg_color;
        @define-color card_fg_color ${cfg.text};
        @define-color card_shade_color rgba(0, 0, 0, 0.36);

        /* Dialog */
        @define-color dialog_bg_color ${background-alternate};
        @define-color dialog_fg_color ${cfg.text};

        /* Popover */
        @define-color popover_bg_color @dialog_bg_color;
        @define-color popover_fg_color ${cfg.text};

        /* Misc */
        @define-color shade_color rgba(0, 0, 0, 0.36);
        @define-color scrollbar_outline_color rgba(0, 0, 0, 0.5);

        /* Sidebar */
        @define-color sidebar_bg_color ${cfg.background-window};
        @define-color sidebar_fg_color ${cfg.text};
        @define-color sidebar_backdrop_color #2a2a2a;
        @define-color sidebar_shade_color rgba(0, 0, 0, 0.36);
        @define-color secondary_sidebar_bg_color #2a2a2a;
        @define-color secondary_sidebar_fg_color ${cfg.text};
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
          color: ${cfg.text-inactive};
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

        # Needed for file picker to work
        kio
        # qt5; copied from https://github.com/NixOS/nixpkgs/blob/2c1ba84cf12458211553686755392dde5436e66e/nixos/modules/services/desktop-managers/plasma6.nix
        (let
          kioPluginPath =
            "${pkgs.plasma5Packages.qtbase.qtPluginPrefix}/kf5/kio";
          inherit (pkgs.plasma5Packages) kio;
        in pkgs.runCommand "kio5-plugins-only" { } ''
          mkdir -p $out/${kioPluginPath}
          ln -s ${kio}/${kioPluginPath}/* $out/${kioPluginPath}
        '')

        # For KColorSchemeEditor: systemsettings, plasma-workspace
      ];
      style.package = [ pkgs.kdePackages.breeze pkgs.kdePackages.breeze.qt5 ];
    };

    # Make the kde platformtheme use the xdg desktop portal filepicker.
    # This doesn't seem to be documented anywhere and is taken from the source code.
    # https://github.com/KDE/plasma-integration
    home.sessionVariables.PLASMA_INTEGRATION_USE_PORTAL = 1;

    xdg.configFile = {
      "kdeglobals".text = let
        qtColor = hex:
          lib.concatStringsSep ","
          (map (x: toString (myLib.hexToDec (lib.substring x 2 hex))) [
            1
            3
            5
          ]);

        # TODO: Color naming; generalize colors together with gtk colors
        accent-hover = "#83A598";
        text-inactive = cfg.text-inactive;
        text-active = "#B8BB26";
        text-negative = cfg.error;
        text-neutral = "#F67400";
        text-positive = "#27AE60";
        link = accent-standalone;
        link-visited = "#7F8C8D";
        link-selected = "#FDBC4B";
        color13 = "#FCFCFC";
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
        Enable=false
        IntensityAmount=0
        IntensityEffect=0

        [Colors:Button]
        BackgroundAlternate=${qtColor background-alternate}
        BackgroundNormal=${qtColor cfg.background-window}
        DecorationFocus=${qtColor cfg.accent}
        DecorationHover=${qtColor accent-hover}
        ForegroundActive=${qtColor link}
        ForegroundInactive=${qtColor text-inactive}
        ForegroundLink=${qtColor text-active}
        ForegroundNegative=${qtColor text-negative}
        ForegroundNeutral=${qtColor text-neutral}
        ForegroundNormal=${qtColor cfg.text}
        ForegroundPositive=${qtColor text-positive}
        ForegroundVisited=${qtColor link-visited}

        [Colors:Complementary]
        BackgroundAlternate=${qtColor background-alternate}
        BackgroundNormal=${qtColor cfg.background-window}
        DecorationFocus=${qtColor cfg.accent}
        DecorationHover=${qtColor accent-hover}
        ForegroundActive=${qtColor text-active}
        ForegroundInactive=${qtColor text-inactive}
        ForegroundLink=${qtColor link}
        ForegroundNegative=${qtColor text-negative}
        ForegroundNeutral=${qtColor text-neutral}
        ForegroundNormal=${qtColor cfg.text}
        ForegroundPositive=${qtColor text-positive}
        ForegroundVisited=${qtColor link-visited}

        [Colors:Header]
        BackgroundAlternate=${qtColor cfg.headerbar-background-inactive}
        BackgroundNormal=${qtColor cfg.headerbar-background}
        ForegroundActive=${qtColor text-active}
        ForegroundLink=${qtColor link-selected}

        [Colors:Header][Inactive]
        BackgroundAlternate=${qtColor cfg.headerbar-background}
        BackgroundNormal=${qtColor cfg.headerbar-background-inactive}
        ForegroundActive=${qtColor text-active}
        ForegroundLink=${qtColor link-selected}

        [Colors:Selection]
        BackgroundAlternate=${qtColor link}
        BackgroundNormal=${qtColor cfg.accent}
        DecorationFocus=${qtColor cfg.accent}
        DecorationHover=${qtColor accent-hover}
        ForegroundActive=${qtColor color13}
        ForegroundInactive=${qtColor cfg.text}
        ForegroundLink=${qtColor link-selected}
        ForegroundNegative=${qtColor text-negative}
        ForegroundNeutral=${qtColor text-neutral}
        ForegroundNormal=${qtColor cfg.accent-text}
        ForegroundPositive=${qtColor text-positive}
        ForegroundVisited=${qtColor color15}

        [Colors:Tooltip]
        BackgroundAlternate=${qtColor background-alternate}
        BackgroundNormal=${qtColor cfg.background-window}
        DecorationFocus=${qtColor cfg.accent}
        DecorationHover=${qtColor accent-hover}
        ForegroundActive=${qtColor text-active}
        ForegroundInactive=${qtColor text-inactive}
        ForegroundLink=${qtColor link}
        ForegroundNegative=${qtColor text-negative}
        ForegroundNeutral=${qtColor text-neutral}
        ForegroundNormal=${qtColor cfg.text}
        ForegroundPositive=${qtColor text-positive}
        ForegroundVisited=${qtColor link-visited}

        [Colors:View]
        BackgroundAlternate=${qtColor background-alternate}
        BackgroundNormal=${qtColor cfg.background-view}
        DecorationFocus=${qtColor cfg.accent}
        DecorationHover=${qtColor accent-hover}
        ForegroundActive=${qtColor text-active}
        ForegroundInactive=${qtColor text-inactive}
        ForegroundLink=${qtColor link}
        ForegroundNegative=${qtColor text-negative}
        ForegroundNeutral=${qtColor text-neutral}
        ForegroundNormal=${qtColor cfg.text}
        ForegroundPositive=${qtColor text-positive}
        ForegroundVisited=${qtColor link-visited}

        [Colors:Window]
        BackgroundAlternate=${qtColor background-alternate}
        BackgroundNormal=${qtColor cfg.background-window}
        DecorationFocus=${qtColor cfg.accent}
        DecorationHover=${qtColor accent-hover}
        ForegroundActive=${qtColor text-active}
        ForegroundInactive=${qtColor text-inactive}
        ForegroundLink=${qtColor link}
        ForegroundNegative=${qtColor text-negative}
        ForegroundNeutral=${qtColor text-neutral}
        ForegroundNormal=${qtColor cfg.text}
        ForegroundPositive=${qtColor text-positive}
        ForegroundVisited=${qtColor link-visited}

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
        activeBlend=${qtColor cfg.text}
        activeFont=Sans Serif,10,-1,5,50,0,0,0,0,0
        activeForeground=${qtColor cfg.text}
        inactiveBackground=${qtColor cfg.background-window}
        inactiveBlend=${qtColor background-alternate}
        inactiveForeground=204,190,155
      '';

      "kcminputrc".text = ''
        [Mouse]
        cursorTheme=${config.home.pointerCursor.name}
      '';
    };
  };
}
