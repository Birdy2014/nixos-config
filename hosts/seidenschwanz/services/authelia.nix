{ config, ... }:

{
  services.authelia.instances.main = {
    enable = true;

    settings = {
      server.address = "tcp://:9091/";

      theme = "auto";

      access_control.default_policy = "one_factor";

      identity_providers.oidc = {
        authorization_policies.immich = {
          default_policy = "deny";
          rules = [{
            subject = "group:immich";
            policy = "one_factor";
          }];
        };

        clients = [{
          client_name = "immich";
          client_id =
            "WKt0QaP4K0gVvOMPSKb0RA4DSj.pSzqfQP1Z-9QK1tSL0-guUAqN2b22maNyGner";
          client_secret =
            "$pbkdf2-sha512$310000$mD0NvJt7jqVOTguxSh7XOA$nH3Cg0FlQ/MM41prPpC75fIbNCO/Gw7Bt9Y1WnmNNC3paJ7oe7cCSsOksRKpKxHqUDSTAHZhQsol.M9sl3BWrw";
          public = false;
          authorization_policy = "immich";
          redirect_uris = [
            "https://immich.seidenschwanz.mvogel.dev/auth/login"
            "https://immich.seidenschwanz.mvogel.dev/user-settings"
            "app.immich:///oauth-callback"
          ];
          scopes = [ "openid" "profile" "email" ];
          userinfo_signed_response_alg = "none";
          token_endpoint_auth_method = "client_secret_basic";
        }];
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

    secrets = with config.sops; {
      jwtSecretFile = secrets."authelia/jwtSecretFile".path;
      storageEncryptionKeyFile =
        secrets."authelia/storageEncryptionKeyFile".path;
      oidcIssuerPrivateKeyFile =
        secrets."authelia/oidcIssuerPrivateKeyFile".path;
      oidcHmacSecretFile = secrets."authelia/oidcHmacSecretFile".path;
    };

    environmentVariables = {
      AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE =
        config.sops.secrets.ldap-admin-password.path;
    };
  };

  my.proxy.domains.auth.proxyPass = "http://localhost:9091";
  services.nginx.virtualHosts.auth.locations."/".recommendedProxySettings =
    true;
}
