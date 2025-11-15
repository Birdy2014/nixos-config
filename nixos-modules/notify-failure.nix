{ config, pkgs, ... }:

{
  systemd.services."notify-failure@" = {
    environment.SERVICE = "%i";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
      TimeoutStartSec = "1min";
    };
    script = ''
      HOSTNAME="$(hostnamectl hostname)"

      ${pkgs.curl}/bin/curl -s \
        -u ":$(< ${config.sops.secrets.ntfy-sender-token.path})" \
        -H "Title: service failure on $HOSTNAME" \
        -d "host: $HOSTNAME"$'\n'"service: $SERVICE" \
        https://ntfy.mvogel.dev/monitoring
    '';
  };
}
