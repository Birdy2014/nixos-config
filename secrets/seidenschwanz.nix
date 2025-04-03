{ config, lib, ... }:

{
  sops.secrets = let file = "/etc/nixos-secrets/seidenschwanz.yaml";
  in {
    ldap-admin-password = {
      sopsFile = file;
      # Ugly workaround to let both paperless and authelia read the file.
      # TODO: Remove authelia?
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

    "wireguard/private-key" = {
      sopsFile = file;
      owner = "systemd-network";
      group = "systemd-network";
    };

    syncthing-api-key = {
      sopsFile = file;
      owner = config.services.syncthing.user;
      group = config.services.syncthing.group;
    };
  } // lib.genAttrs (map (n: "wireguard/psk${toString n}") [ 2 3 4 5 7 ]) (_: {
    sopsFile = file;
    owner = "systemd-network";
    group = "systemd-network";
  });
}
