{ config, pkgs, ... }:

let fqdn = "cloud.mvogel.dev";
in {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = fqdn;
    config = {
      adminpassFile = config.sops.secrets.nextcloud-admin-password.path;
      dbtype = "pgsql";
    };
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit contacts calendar notes;
    };
    extraAppsEnable = true;
    https = true;
    configureRedis = true;
    phpOptions."opcache.interned_strings_buffer" = "16";
    database.createLocally = true;

    settings = {
      default_language = "de";
      default_locale = "de_DE";
      maintenance_window_start = 3;
    };
  };

  services.nginx.virtualHosts.${fqdn} = {
    forceSSL = true;
    enableACME = true;
  };
}
