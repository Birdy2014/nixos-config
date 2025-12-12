{
  config,
  lib,
  ...
}:

{
  options.my.desktop = {
    enable = lib.mkEnableOption "the desktop module";

    colorscheme = lib.mkOption {
      type = lib.types.enum [
        "gruvbox-material-dark"
        "gruvbox-material-light"
        "catppuccin-frappe"
        "catppuccin-macchiato"
        "catppuccin-latte"
        "kanso-mist"
        "kanso-pearl"
      ];
      default = "gruvbox-material-dark";
      description = "Which colorscheme to use";
    };

    compositor = lib.mkOption {
      type = lib.types.enum [
        "niri"
        "sway"
      ];
      default = "niri";
      description = "wayland compositor";
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

  config = lib.mkIf (config.my.desktop.enable) {
    hardware.graphics.enable = true;

    security = {
      rtkit.enable = true;
      polkit.enable = true;
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    programs.dconf.enable = true;

    services.udisks2.enable = true;

    # Needed for mDNS
    networking.firewall.allowedUDPPorts = [ 5353 ];
    services.resolved.llmnr = "false";

    # silent boot
    boot.consoleLogLevel = 3;
    boot.kernelParams = [ "quiet" ];
    boot.plymouth.enable = true;
  };
}
