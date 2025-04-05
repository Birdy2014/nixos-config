{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

{
  config =
    let
      inherit (osConfig.my.desktop) compositor;
    in
    lib.mkIf (compositor == "sway" || compositor == "niri") {
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
    };
}
