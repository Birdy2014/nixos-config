{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf osConfig.my.desktop.enable {
    programs.swaylock = {
      enable = true;
      settings.color = lib.substring 1 6 config.my.theme.background-tertiary;
    };

    services.wlsunset = {
      enable = true;
      latitude = "50.1";
      longitude = "8.7";
    };

    services.flameshot = {
      enable = true;
      package = pkgs.flameshot.override { enableWlrSupport = true; };
      settings.General = {
        disabledGrimWarning = true;
        disabledTrayIcon = true;
        saveAsFileExtension = ".png";
        savePath = "${config.xdg.userDirs.pictures}/screenshots";
        savePathFixed = true;
      };
    };

    # The flameshot service always fails to start
    systemd.user.services.flameshot = lib.mkForce { };

    home.packages = with pkgs; [
      libnotify
      wl-clipboard
    ];

    # Based on https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/security/soteria.nix
    systemd.user.services.soteria = {
      Unit = {
        Description = "Soteria, Polkit authentication agent for any desktop environment";
        After = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = lib.getExe pkgs.soteria;
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
