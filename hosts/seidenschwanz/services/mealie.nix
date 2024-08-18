{ config, inputs, pkgs, pkgsUnstable, ... }:

{
  disabledModules = [ "services/web-apps/mealie.nix" ];

  imports =
    [ (inputs.nixpkgs-unstable + /nixos/modules/services/web-apps/mealie.nix) ];

  services.mealie = {
    enable = true;
    port = 8134;

    # Remove override once https://github.com/NixOS/nixpkgs/pull/334231 is in unstable
    package = pkgsUnstable.mealie.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        (pkgs.fetchpatch {
          url =
            "https://github.com/mealie-recipes/mealie/commit/65ece35966120479db903785b22e9f2645f72aa4.patch";
          hash = "sha256-4Nc0dFJrZ7ElN9rrq+CFpayKsrRjRd24fYraUFTzcH8=";
        })
      ];
    });

    settings = {
      ALLOW_SIGNUP = "false";
      BASE_URL = "https://recipes.seidenschwanz.mvogel.dev";
      TOKEN_TIME = "720"; # 30 Tage
      TZ = "Europe/Berlin";

      LDAP_AUTH_ENABLED = "true";
      LDAP_SERVER_URL = "ldap://[::1]:3890";
      LDAP_BASE_DN = "ou=people,dc=mvogel,dc=dev";
      LDAP_QUERY_BIND = "cn=admin,ou=people,dc=mvogel,dc=dev";
      LDAP_USER_FILTER = "(memberOf=cn=mealie,ou=groups,dc=mvogel,dc=dev)";
      LDAP_ADMIN_FILTER =
        "(memberOf=cn=lldap_admin,ou=groups,dc=mvogel,dc=dev)";
      LDAP_NAME_ATTRIBUTE = "displayName";
    };

    credentialsFile =
      config.sops.templates."mealie-ldap-admin-password.env".path;
  };

  my.proxy.domains.recipes.proxyPass = "http://localhost:8134";

  sops.templates."mealie-ldap-admin-password.env".content = ''
    LDAP_QUERY_PASSWORD=${config.sops.placeholder.ldap-admin-password}
  '';
}
