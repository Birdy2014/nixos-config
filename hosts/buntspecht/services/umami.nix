{ config, ... }:

{
  services.umami = {
    # TODO: Enable after update to 3.0.2
    enable = false;
    settings = {
      APP_SECRET_FILE = config.sops.secrets.umami-app-secret.path;
      PORT = 3010;
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "analytics.improglycerin.de" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/robots.txt".return = "200 'User-agent: *\\nDisallow: /\\n'";
          "/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.umami.settings.PORT}/";
            recommendedProxySettings = true;
          };
        };
      };
    };
  };
}
