{ config, ... }:

{
  services.paperless = {
    enable = true;
    # Stored on ssd because the database and logs are written frequently
    dataDir = "/var/lib/paperless";
    settings = {
      PAPERLESS_URL = "https://paperless.seidenschwanz.mvogel.dev";

      PAPERLESS_ENABLE_HTTP_REMOTE_USER = true;
      PAPERLESS_ADMIN_USER = "admin";
      PAPERLESS_LOGOUT_REDIRECT_URL =
        "https://auth.seidenschwanz.mvogel.dev/logout";
    };
  };

  my.proxy.domains.paperless = {
    proxyPass = "http://${config.services.paperless.address}:${
        toString config.services.paperless.port
      }";
    enableAuthelia = true;
  };

  services.nginx.virtualHosts.paperless.locations."/".proxyWebsockets = true;
}
