{ config, pkgs, ... }:

{
  services.smartd = {
    enable = true;
    notifications.mail = {
      enable = true;
      mailer = pkgs.writeShellScript "smartd-ntfy" ''
        ${pkgs.curl}/bin/curl -s \
          -u ":$(< ${config.sops.secrets.ntfy-sender-token.path})" \
          -H "Title: $SMARTD_SUBJECT" \
          -d "Type: $SMARTD_FAILTYPE"$'\n'"Time: $SMARTD_TFIRST"$'\n'"$SMARTD_FULLMESSAGE" \
          https://ntfy.mvogel.dev/monitoring
      '';
    };
  };
}
