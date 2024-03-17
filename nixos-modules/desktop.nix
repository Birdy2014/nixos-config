{ config, lib, pkgs, ... }:

{
  options.my.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = lib.mdDoc "Whether to enable the desktop";
    };

    screens = {
      primary = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = lib.mdDoc
          "Name of primary screen as shown by `swaymsg -t get_outputs`";
      };

      secondary = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = lib.mdDoc
          "Name of secondary screen as shown by `swaymsg -t get_outputs`";
      };
    };
  };

  config = lib.mkIf config.my.desktop.enable {
    hardware.opengl.enable = true;

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
    security.pam.services.moritz.enableGnomeKeyring = true;
    security.pam.services.swaylock = { };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config = {
        common.default = "*";
        sway.default = [ "wlr" "gtk" ];
      };
    };

    fonts = {
      enableDefaultPackages = true;

      fontconfig = {
        enable = true;

        defaultFonts.serif = [ "NotoSerif Nerd Font" "Noto Serif CJK JP" ];
        defaultFonts.sansSerif = [ "NotoSans Nerd Font" "Noto Sans CJK JP" ];
        defaultFonts.monospace =
          [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK JP" ];
        defaultFonts.emoji = [ "Noto Color Emoji" ];
      };

      packages = with pkgs; [
        (nerdfonts.override { fonts = [ "JetBrainsMono" "Noto" ]; })
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        corefonts
      ];
    };

    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
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
          globalOptions = {
            "Hotkey/TriggerKeys" = { "0" = "Super_R"; };
            # waylandim is currently broken with sway
            "Behavior/DisabledAddons"."0" = "waylandim";
          };
        };
      };
    };

    services.syncthing = {
      enable = true;
      user = "moritz";
      group = "users";
      overrideFolders = false;
      overrideDevices = false;
      configDir = "${config.users.users.moritz.home}/.config/syncthing";
      dataDir = "${config.users.users.moritz.home}/.local/state/syncthing";
    };

    # For accessing SMB shares with `gio mount`
    services.gvfs.enable = true;
    environment.systemPackages = [ pkgs.glib ];

    programs.thunar.enable = true;
    services.tumbler.enable = true;
    programs.xfconf.enable = true;
  };
}
