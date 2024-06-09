{ config, ... }:

{
  sops.secrets = let file = "/etc/nixos-secrets/seidenschwanz.yaml";
  in {
    ldap-admin-password = {
      sopsFile = file;
      owner = config.services.authelia.instances.main.user;
      group = config.services.authelia.instances.main.group;
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

    "wireguard/private-key" = {
      sopsFile = file;
      owner = "systemd-network";
      group = "systemd-network";
    };

    ddclient.sopsFile = file;
  };
}
