{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the desktop and user 'moritz'";
    };

    colorscheme = lib.mkOption {
      type = lib.types.enum [
        "gruvbox-material-dark"
        "gruvbox-material-light"
        "catppuccin-frappe"
        "catppuccin-macchiato"
        "catppuccin-latte"
      ];
      default = "gruvbox-material-dark";
      description = "Which colorscheme to use";
    };

    screens = {
      primary = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Name of primary screen as shown by `swaymsg -t get_outputs`";
      };

      secondary = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Name of secondary screen as shown by `swaymsg -t get_outputs`";
      };
    };
  };

  config = lib.mkIf config.my.desktop.enable {
    hardware.graphics.enable = true;

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    programs.dconf.enable = true;

    security.polkit.enable = true;

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.swaylock.enable = true;

    services.udisks2.enable = true;

    # Needed for home-manager configured xdg-desktop-portal
    environment.pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];

    fonts = {
      enableDefaultPackages = true;

      fontDir.enable = true;

      fontconfig = {
        enable = true;

        defaultFonts.serif = [
          "NotoSerif Nerd Font"
          "Noto Serif CJK JP"
        ];
        defaultFonts.sansSerif = [
          "NotoSans Nerd Font"
          "Noto Sans CJK JP"
        ];
        defaultFonts.monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Sans Mono CJK JP"
        ];
        defaultFonts.emoji = [ "Noto Color Emoji" ];
      };

      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.noto
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        corefonts
        vistafonts
      ];
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
        ];
        settings = {
          inputMethod = {
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "de-nodeadkeys";
              DefaultIM = "mozc";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-de-nodeadkeys";
              Layout = "";
            };
            "Groups/0/Items/1" = {
              Name = "mozc";
              Layout = "";
            };
            "GroupOrder"."0" = "Default";
          };
          # The F13 key is called "Tools" for some reason
          globalOptions."Hotkey/TriggerKeys"."0" = "Tools";
        };
      };
    };

    services.syncthing = {
      enable = true;
      user = "moritz";
      group = "users";
      overrideFolders = false;
      overrideDevices = false;
      openDefaultPorts = true;
      configDir = "${config.users.users.moritz.home}/.config/syncthing";
      dataDir = "${config.users.users.moritz.home}/.local/state/syncthing";
    };

    # Needed for mDNS
    networking.firewall.allowedUDPPorts = [ 5353 ];
    services.resolved.llmnr = "false";

    # For accessing SMB shares with `gio mount`
    services.gvfs.enable = true;
    environment.systemPackages = [ pkgs.glib ];

    programs.thunar.enable = true;
    services.tumbler.enable = true;
    programs.xfconf.enable = true;
  };
}
