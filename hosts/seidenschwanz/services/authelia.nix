{ config, ... }:

{
  services.authelia.instances.main = {
    enable = true;

    settings = {
      server.address = "tcp://:9091/";

      theme = "auto";

      access_control = {
        default_policy = "deny";
        rules = [
          # Allow use of paperless mobile app when not using OIDC
          {
            domain = [ "paperless.seidenschwanz.mvogel.dev" ];
            resources = [ "^/api([/?].*)?$" ];
            policy = "bypass";
          }

          # Only allow ldap users in the 'paperless' group to access the paperless web interface
          {
            domain = [ "paperless.seidenschwanz.mvogel.dev" ];
            subject = "group:paperless";
            policy = "one_factor";
          }
        ];
      };

      session.cookies = [{
        domain = "seidenschwanz.mvogel.dev";
        authelia_url = "https://auth.seidenschwanz.mvogel.dev";
      }];

      storage.local.path = "/var/lib/authelia-main/authelia.db";

      notifier.filesystem.filename = "/var/lib/authelia-main/notifications";

      authentication_backend = {
        password_reset.disable = true;
        ldap = {
          attributes = {
            username = "uid";
            group_name = "cn";
            mail = "mail";
            display_name = "displayName";
          };
          implementation = "custom";
          address = "ldap://[::1]:3890";
          timeout = "5s";
          start_tls = false;
          base_dn = "dc=mvogel,dc=dev";
          additional_users_dn = "ou=people";
          users_filter =
            "(&({username_attribute}={input})(objectClass=person))";
          additional_groups_dn = "ou=groups";
          groups_filter = "(member={dn})";
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
  services.nginx.virtualHosts.auth.locations."/".recommendedProxySettings =
    true;
}
