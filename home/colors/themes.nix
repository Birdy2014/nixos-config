{
  inputs,
  lib,
  myLib,
  pkgs,
  pkgsSelf,
  config,
  ...
}:

{
  options.my.theme =
    lib.genAttrs
      [
        "accent"
        "accent-background"
        "accent-complementary"
        "background-primary"
        "background-secondary"
        "background-tertiary"
        "text"
        "text-inactive"
        "error"
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
      ]
      (
        name:
        lib.mkOption {
          type = lib.types.str;
          description = "color";
        }
      )
    // {
      accent-text = lib.mkOption {
        type = lib.types.enum [
          "#000000"
          "#ffffff"
        ];
        description = "color";
      };

      isLight = lib.mkOption {
        type = lib.types.bool;
        description = "is a light theme";
        default = false;
      };
    };

  config =
    let
      cfg = config.my.theme;

      colorizer = inputs.nix-colorizer;
      darken = hex: percent: colorizer.oklchToHex (colorizer.darken (colorizer.hexToOklch hex) percent);
      lighten = hex: percent: colorizer.oklchToHex (colorizer.lighten (colorizer.hexToOklch hex) percent);
      complementary = hex: colorizer.oklchToHex (colorizer.complementary (colorizer.hexToOklch hex));
    in
    {
      my.theme = {
        accent-background = lib.mkDefault (darken cfg.accent 20);

        accent-complementary = lib.mkDefault (complementary cfg.accent-background);
        error = lib.mkDefault (darken cfg.red 20);

        light-black = lib.mkDefault (lighten cfg.black 10);
        light-red = lib.mkDefault (lighten cfg.red 10);
        light-green = lib.mkDefault (lighten cfg.green 10);
        light-yellow = lib.mkDefault (lighten cfg.yellow 10);
        light-blue = lib.mkDefault (lighten cfg.blue 10);
        light-magenta = lib.mkDefault (lighten cfg.magenta 10);
        light-cyan = lib.mkDefault (lighten cfg.cyan 10);
        light-white = lib.mkDefault (lighten cfg.white 10);
      };

      home.pointerCursor = {
        name = "LyraX-cursors";
        size = 24;
        package = pkgsSelf.lyrax-cursors;
        gtk.enable = true;
      };

      home.packages = [ pkgs.adw-gtk3 ];

      gtk =
        let
          # Reference: https://gnome.pages.gitlab.gnome.org/libadwaita/doc/main/css-variables.html
          cssVariables = rec {
            # Accent
            accent-bg-color = cfg.accent-background;
            accent-fg-color = cfg.accent-text; # accent-fg-color apparently must be either black or white
            accent-color = cfg.accent;

            # Destructive
            destructive-color = "#ff7b63";
            destructive-bg-color = "#c01c28";
            destructive-fg-color = cfg.text;

            # Success
            success-color = "#a9b665";
            success-bg-color = "#26a269";
            success-fg-color = cfg.text;

            # Warning
            warning-color = "#d8a657";
            warning-bg-color = "#cd9309";
            warning-fg-color = "rgba(0, 0, 0, 0.8)";

            # Error
            error-color = cfg.error;
            error-bg-color = "#e33e35";
            error-fg-color = cfg.text;

            # Window
            window-bg-color = cfg.background-primary;
            window-fg-color = cfg.text;

            # View
            view-bg-color = cfg.background-secondary;
            view-fg-color = cfg.text;

            # Headerbar
            headerbar-bg-color = cfg.background-primary;
            headerbar-fg-color = cfg.text;
            headerbar-border-color = "#D4BE98";
            headerbar-backdrop-color = cfg.background-tertiary;
            headerbar-shade-color = "rgba(0, 0, 0, 0.36)";

            # Card
            card-bg-color = dialog-bg-color;
            card-fg-color = cfg.text;
            card-shade-color = "rgba(0, 0, 0, 0.36)";

            # Dialog
            dialog-bg-color = cfg.background-tertiary;
            dialog-fg-color = cfg.text;

            # Popover
            popover-bg-color = dialog-bg-color;
            popover-fg-color = cfg.text;

            # Misc
            shade-color = "rgba(0, 0, 0, 0.36)";
            scrollbar-outline-color = "rgba(0, 0, 0, 0.5)";

            # Sidebar
            sidebar-bg-color = cfg.background-primary;
            sidebar-fg-color = cfg.text;
            sidebar-backdrop-color = cfg.background-secondary;
            sidebar-shade-color = "rgba(0, 0, 0, 0.36)";
            secondary-sidebar-bg-color = cfg.background-secondary;
            secondary-sidebar-fg-color = cfg.text;
            secondary-sidebar-backdrop-color = darken cfg.background-secondary 20;
            secondary-sidebar-shade-color = sidebar-shade-color;
          };

          extraCss = ''
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
        in
        {
          enable = true;

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
            "file:///run/media/moritz/archive Archive"
            "file:///run/media/moritz/smb-shares SMB shares"
          ];

          gtk3 = {
            extraConfig.gtk-theme-name = if cfg.isLight then "adw-gtk3" else "adw-gtk3-dark";
            extraCss =
              lib.concatLines (
                lib.mapAttrsToList (
                  variable: value: "@define-color ${lib.replaceStrings [ "-" ] [ "_" ] variable} ${value};"
                ) cssVariables
              )
              + extraCss;
          };

          gtk4.extraCss = ''
            :root {
            ${lib.concatLines (lib.mapAttrsToList (variable: value: "--${variable}: ${value};") cssVariables)}
            }

            ${extraCss}
          '';
        };

      dconf.settings = {
        "org/gnome/desktop/interface".color-scheme = if cfg.isLight then "prefer-light" else "prefer-dark";

        "org/gnome/desktop/interface".gtk-theme = if cfg.isLight then "adw-gtk3" else "adw-gtk3-dark";

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
          (
            let
              kioPluginPath = "${pkgs.plasma5Packages.qtbase.qtPluginPrefix}/kf5/kio";
              inherit (pkgs.plasma5Packages) kio;
            in
            pkgs.runCommand "kio5-plugins-only" { } ''
              mkdir -p $out/${kioPluginPath}
              ln -s ${kio}/${kioPluginPath}/* $out/${kioPluginPath}
            ''
          )

          # For KColorSchemeEditor: systemsettings, plasma-workspace
        ];
        style.package = [
          pkgs.kdePackages.breeze
          pkgs.kdePackages.breeze.qt5
        ];
      };

      # Make the kde platformtheme use the xdg desktop portal filepicker.
      # This doesn't seem to be documented anywhere and is taken from the source code.
      # https://github.com/KDE/plasma-integration
      home.sessionVariables.PLASMA_INTEGRATION_USE_PORTAL = 1;

      xdg.configFile = {
        "kdeglobals".text =
          let
            qtColor =
              hex:
              lib.concatStringsSep "," (
                map (x: toString (myLib.hexToDec (lib.substring x 2 hex))) [
                  1
                  3
                  5
                ]
              );

            # TODO: Color naming; generalize colors together with gtk colors
            accent-hover = lighten cfg.accent 10;
            text-inactive = cfg.text-inactive;
            text-active = "#B8BB26";
            text-negative = cfg.error;
            text-neutral = "#F67400";
            text-positive = "#27AE60";
            link = cfg.yellow;
            link-visited = "#7F8C8D";
            link-selected = "#FDBC4B";
            color15 = "#BDC3C7";

            # Based on https://store.kde.org/p/1327717/
          in
          ''
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
            BackgroundAlternate=${qtColor cfg.background-tertiary}
            BackgroundNormal=${qtColor cfg.background-primary}
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
            BackgroundAlternate=${qtColor cfg.background-tertiary}
            BackgroundNormal=${qtColor cfg.background-primary}
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
            BackgroundAlternate=${qtColor cfg.background-tertiary}
            BackgroundNormal=${qtColor cfg.background-primary}
            ForegroundActive=${qtColor text-active}
            ForegroundLink=${qtColor link-selected}

            [Colors:Header][Inactive]
            BackgroundAlternate=${qtColor cfg.background-primary}
            BackgroundNormal=${qtColor cfg.background-tertiary}
            ForegroundActive=${qtColor text-active}
            ForegroundLink=${qtColor link-selected}

            [Colors:Selection]
            BackgroundAlternate=${qtColor link}
            BackgroundNormal=${qtColor cfg.accent-background}
            DecorationFocus=${qtColor cfg.accent-background}
            DecorationHover=${qtColor accent-hover}
            ForegroundActive=${qtColor cfg.accent-text}
            ForegroundInactive=${qtColor cfg.text}
            ForegroundLink=${qtColor link-selected}
            ForegroundNegative=${qtColor text-negative}
            ForegroundNeutral=${qtColor text-neutral}
            ForegroundNormal=${qtColor cfg.accent-text}
            ForegroundPositive=${qtColor text-positive}
            ForegroundVisited=${qtColor color15}

            [Colors:Tooltip]
            BackgroundAlternate=${qtColor cfg.background-tertiary}
            BackgroundNormal=${qtColor cfg.background-primary}
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
            BackgroundAlternate=${qtColor cfg.background-tertiary}
            BackgroundNormal=${qtColor cfg.background-secondary}
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
            BackgroundAlternate=${qtColor cfg.background-tertiary}
            BackgroundNormal=${qtColor cfg.background-primary}
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
            TerminalApplication=foot
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
            inactiveBackground=${qtColor cfg.background-primary}
            inactiveBlend=${qtColor cfg.background-tertiary}
            inactiveForeground=204,190,155
          '';

        "kcminputrc".text = ''
          [Mouse]
          cursorTheme=${config.home.pointerCursor.name}
        '';
      };
    };
}
