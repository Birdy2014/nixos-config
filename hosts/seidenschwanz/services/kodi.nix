{ pkgs, ... }:

{
  users.groups.kodi = { };
  users.users.kodi = {
    isSystemUser = true;
    group = "kodi";
    home = "/var/lib/kodi";
    createHome = true;
    extraGroups = [ "video" "input" "pipewire" ];
  };

  networking.firewall.allowedTCPPorts = [ 8080 9090 ];
  networking.firewall.allowedUDPPorts = [ 9777 ];

  hardware.graphics.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    systemWide = true;
  };

  # If audio doesn't work, the videos will freeze after a few seconds.
  # Audio breaks when changing the display refresh rate through kodi.
  # After restarting kodi, audio works again.
  # -> disable automatic refresh rate adjustment in kodi!
  # Also, kodi will segfault when trying to set the display refresh rate to 23.976Hz.

  systemd.services.kodi = let
    package = pkgs.kodi-gbm.withPackages
      (kodiPackages: with kodiPackages; [ inputstream-adaptive ]);
  in {
    description = "Kodi media center";

    after = [
      "network-online.target"
      "sound.target"
      "systemd-user-sessions.service"
    ];
    wants = [ "network-online.target" ];

    conflicts = [ "kodi.socket" ];

    serviceConfig = {
      Type = "simple";
      User = "kodi";
      ExecStart = "${package}/bin/kodi-standalone";
      Restart = "always";
      TimeoutStopSec = "15s";
      TimeoutStopFailureMode = "kill";
    };
  };

  systemd.sockets.kodi = {
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "8080" ];
    conflicts = [ "kodi.service" ];
  };
}
