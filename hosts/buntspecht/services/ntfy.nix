{ config, ... }:

{
  services.ntfy-sh = {
    enable = true;
    settings = {
      listen-http = "127.0.0.1:3020";
      base-url = "https://ntfy.mvogel.dev";
      auth-default-access = "deny-all";
      behind-proxy = true;
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "ntfy.mvogel.dev" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}/";
          recommendedProxySettings = true;
          proxyWebsockets = true;
        };
      };
    };
  };
}
