{ config, ... }:

{
  services.harmonia = {
    enable = true;
    signKeyPaths = [ config.sops.secrets.cache-private-key.path ];
    settings = {
      bind = "[::]:5000";
      # compression defaults to false with next version?
      # enable_compression = true;
    };
  };

  my.proxy.domains.cache.proxyPass = "http://${config.services.harmonia.settings.bind}";
}
