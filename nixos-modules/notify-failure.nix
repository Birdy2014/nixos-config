{ config, pkgs, ... }:

{
  systemd.services."notify-failure@" = {
    environment.SERVICE = "%i";
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
