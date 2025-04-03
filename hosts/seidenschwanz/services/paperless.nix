{ config, ... }:

{
  services.paperless = {
    enable = true;

    # Stored on ssd because the database and logs are written frequently
    dataDir = "/var/lib/paperless";

    settings = {
      PAPERLESS_URL = "https://paperless.seidenschwanz.mvogel.dev";

      PAPERLESS_ADMIN_USER = "admin";

      # LDAP auth
      DJANGO_SETTINGS_MODULE = "paperless.settings_ldap";
      AUTH_LDAP_SERVER_URI = "ldap://[::1]:3890";
      AUTH_LDAP_BIND_DN = "uid=admin,ou=people,dc=mvogel,dc=dev";
      AUTH_LDAP_BIND_PASSWORD_FILE =
        config.sops.secrets.ldap-admin-password.path;
      AUTH_LDAP_BASE_DN = "ou=people,dc=mvogel,dc=dev";
      AUTH_LDAP_USER_FILTER =
        "(&(uid=%(user)s)(memberOf=cn=paperless,ou=groups,dc=mvogel,dc=dev))";
    };
  };

  my.proxy.domains.paperless.proxyPass =
    "http://${config.services.paperless.address}:${
      toString config.services.paperless.port
    }";

  services.nginx.virtualHosts.paperless.locations."/".proxyWebsockets = true;
}
