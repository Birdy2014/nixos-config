{ config, ... }:

{
  services.harmonia.cache = {
    enable = true;
    signKeyPaths = [ config.sops.secrets.cache-private-key.path ];
    settings = {
      bind = "[::]:5000";
      enable_compression = true;
    };
  };

  my.proxy.domains.cache.proxyPass = "http://${config.services.harmonia.cache.settings.bind}";
}
