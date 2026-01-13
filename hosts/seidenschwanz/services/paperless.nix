{ config, lib, ... }:

{
  services.paperless = {
    enable = true;

    # Stored on ssd because the database and logs are written frequently
    dataDir = "/var/lib/paperless";

    settings = {
      PAPERLESS_URL = "https://paperless.seidenschwanz.mvogel.dev";

      # LDAP auth
      DJANGO_SETTINGS_MODULE = "paperless.settings_ldap";
      AUTH_LDAP_SERVER_URI = "ldap://[::1]:3890";
      AUTH_LDAP_BIND_DN = "uid=admin,ou=people,dc=mvogel,dc=dev";
      AUTH_LDAP_BIND_PASSWORD_FILE = "%d/ldap_password";
      AUTH_LDAP_USER_BASE_DN = "ou=people,dc=mvogel,dc=dev";
      AUTH_LDAP_USER_FILTER = "(uid=%(user)s)";
      AUTH_LDAP_GROUP_BASE_DN = "ou=groups,dc=mvogel,dc=dev";
      AUTH_LDAP_REQUIRE_GROUP = "cn=paperless,ou=groups,dc=mvogel,dc=dev";
    };
  };

  systemd.services =
    lib.genAttrs [ "paperless-web" "paperless-scheduler" "paperless-task-queue" ]
      (_: {
        serviceConfig.LoadCredential = [
          "ldap_password:${config.sops.secrets.ldap-admin-password.path}"
        ];
      });

  my.proxy.domains.paperless = {
    proxyPass = "http://${config.services.paperless.address}:${toString config.services.paperless.port}";
    proxyWebsockets = true;
  };
}
