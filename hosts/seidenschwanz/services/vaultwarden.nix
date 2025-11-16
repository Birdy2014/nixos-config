{ config, ... }:

{
  services.vaultwarden = {
    enable = true;
    backupDir = "/zpool/backup/vaultwarden";
    environmentFile = config.sops.secrets.vaultwarden-env.path;
    config = {
      ROCKET_ADDRESS = "::1";
      ROCKET_PORT = 8222;

      DOMAIN = "https://vaultwarden.seidenschwanz.mvogel.dev";
      SIGNUPS_ALLOWED = false;
    };
  };

  my.proxy.domains.vaultwarden.proxyPass =
    "http://[::1]:${toString config.services.vaultwarden.config.ROCKET_PORT}";
}
