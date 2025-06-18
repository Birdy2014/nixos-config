{ config, lib, ... }:

{
  sops.secrets =
    let
      file = "/etc/nixos-secrets/seidenschwanz.yaml";
    in
    {
      ldap-admin-password = {
        sopsFile = file;
        # Ugly workaround to let both paperless and authelia read the file.
        owner = config.services.paperless.user;
        group = config.services.authelia.instances.main.group;
        mode = "0440";
      };

      "recipes/secret-key".sopsFile = file;

      "authelia/jwtSecretFile" = {
        sopsFile = file;
        owner = config.services.authelia.instances.main.user;
        group = config.services.authelia.instances.main.group;
      };

      "authelia/storageEncryptionKeyFile" = {
        sopsFile = file;
        owner = config.services.authelia.instances.main.user;
        group = config.services.authelia.instances.main.group;
      };

      "authelia/oidcIssuerPrivateKeyFile" = {
        sopsFile = file;
        owner = config.services.authelia.instances.main.user;
        group = config.services.authelia.instances.main.group;
      };

      "authelia/oidcHmacSecretFile" = {
        sopsFile = file;
        owner = config.services.authelia.instances.main.user;
        group = config.services.authelia.instances.main.group;
      };

      "wireguard/private-key-server" = {
        sopsFile = file;
        owner = "systemd-network";
        group = "systemd-network";
      };

      "wireguard/private-key-client" = {
        sopsFile = file;
        owner = "systemd-network";
        group = "systemd-network";
      };

      syncthing-api-key = {
        sopsFile = file;
        owner = config.services.syncthing.user;
        group = config.services.syncthing.group;
      };

      nullmailer-gmail-password.sopsFile = file;
    }
    //
      lib.genAttrs
        (map (n: "wireguard/psk${toString n}") [
          2
          3
          4
          5
          7
          9
        ])
        (_: {
          sopsFile = file;
          owner = "systemd-network";
          group = "systemd-network";
        });
}
