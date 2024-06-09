{ config, ... }:

{
  services.authelia.instances.main = {
    enable = true;

    settings = {
      server = {
        host = "localhost";
        port = 9091;
      };

      theme = "auto";

      access_control = {
        default_policy = "one_factor";
        rules = [{
          domain = [ "paperless.seidenschwanz.mvogel.dev" ];
          resources = [ "^/api([/?].*)?$" ];
          policy = "bypass";
        }];
      };

      session.domain = "seidenschwanz.mvogel.dev";

      storage.local.path = "/var/lib/authelia-main/authelia.db";

      notifier.filesystem.filename = "/var/lib/authelia-main/notifications";

      authentication_backend = {
        password_reset.disable = true;
        ldap = {
          implementation = "custom";
          url = "ldap://[::1]:3890";
          timeout = "5s";
          start_tls = false;
          base_dn = "dc=mvogel,dc=dev";
          username_attribute = "uid";
          additional_users_dn = "ou=people";
          users_filter =
            "(&({username_attribute}={input})(objectClass=person))";
          additional_groups_dn = "ou=groups";
          groups_filter = "(member={dn})";
          group_name_attribute = "cn";
          mail_attribute = "mail";
          display_name_attribute = "displayName";
          user = "uid=admin,ou=people,dc=mvogel,dc=dev";
        };
      };
    };

    secrets = {
      jwtSecretFile = config.sops.secrets."authelia/jwtSecretFile".path;
      storageEncryptionKeyFile =
        config.sops.secrets."authelia/storageEncryptionKeyFile".path;
    };
  };

  systemd.services.authelia-main.environment.AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE =
    config.sops.secrets.ldap-admin-password.path;

  my.proxy.domains.auth.proxyPass = "http://localhost:9091";
}
