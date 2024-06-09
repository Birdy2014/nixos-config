{ ... }:

{
  services.lldap = {
    enable = true;
    settings = {
      database_url = "sqlite:///var/lib/lldap/users.db?mode=rwc";
      ldap_base_dn = "dc=mvogel,dc=dev";
      ldap_host = "::1";

      smtp_options.enable_password_reset = false;

      ldaps_options.enabled = false;

      http_url = "https://ldap.seidenschwanz.mvogel.dev";
      http_port = 17170;
      http_host = "127.0.0.1";
    };
  };

  users = {
    users.lldap = {
      group = "lldap";
      isSystemUser = true;
    };

    groups.lldap = { };
  };

  my.proxy.domains.ldap.proxyPass = "http://127.0.0.1:17170";
}
