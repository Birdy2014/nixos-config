{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "data";
    group = "data";
    guiAddress = "127.0.0.1:8384";
  };

  my.proxy.domains.syncthing.proxyPass = "http://127.0.0.1:8384";

  # "recommendedProxySettings" is unset on purpose because syncthing will complain about the host header
  services.nginx.virtualHosts.syncthing.extraConfig = ''
    # Syncthing uses long polling and shorter timeouts cause error messages in the web Interface.
    # I'm not sure which timeouts have to be adjusted.
    proxy_connect_timeout 75s;
    proxy_read_timeout 75s;
    proxy_send_timeout 75;
  '';

  sops.templates."syncthing-api-key.env".content = ''
    API_KEY=${config.sops.placeholder.syncthing-api-key}
  '';

  # Full rescan interval should be set to 0 in the syncthing GUI for every folder
  systemd.services.syncthing-periodic-sync = {
    script = ''
      curl -s -H "X-API-Key: $API_KEY" -X POST ${config.my.proxy.domains.syncthing.proxyPass}/rest/db/scan
    '';

    path = [ pkgs.curl ];

    serviceConfig = {
      Type = "oneshot";
      User = config.services.syncthing.user;
      Group = config.services.syncthing.group;
      EnvironmentFile = config.sops.templates."syncthing-api-key.env".path;
    };
  };

  systemd.timers.syncthing-periodic-sync = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "*-*-* 00:00:00";
  };
}
