{ lib, ... }:

{
  sops.secrets =
    let
      file = "/etc/nixos-secrets/buntspecht.yaml";
    in
    {
      "itf/email-auth" = {
        sopsFile = file;
        owner = "itf";
        group = "itf";
      };

      "itf/email-newsletter" = {
        sopsFile = file;
        owner = "itf";
        group = "itf";
      };

      improglycerin-yesticket-api-key = {
        sopsFile = file;
        owner = "improglycerin";
        group = "improglycerin";
      };

      nextcloud-admin-password = {
        sopsFile = file;
        owner = "nextcloud";
        group = "nextcloud";
      };

      coturn-auth-secret = {
        sopsFile = file;
        # needs to be readable by coturn and synapse
        mode = "0444";
      };

      borgbackup-data-key.sopsFile = file;

      umami-app-secret.sopsFile = file;

      "wireguard/private-key-server" = {
        sopsFile = file;
        owner = "systemd-network";
        group = "systemd-network";
      };
    }
    //
      lib.genAttrs
        (map (n: "wireguard/psk${toString n}") [
          2
          6
          7
        ])
        (_: {
          sopsFile = file;
          owner = "systemd-network";
          group = "systemd-network";
        });
}
