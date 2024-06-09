{ config, pkgs, ... }:

let fqdn = "cloud.mvogel.dev";
in {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = fqdn;
    config.adminpassFile = config.sops.secrets.nextcloud-admin-password.path;
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit contacts calendar notes;
    };
    extraAppsEnable = true;
    https = true;
    configureRedis = true;
  };

  services.nginx.virtualHosts.${fqdn} = {
    forceSSL = true;
    enableACME = true;
  };
}
