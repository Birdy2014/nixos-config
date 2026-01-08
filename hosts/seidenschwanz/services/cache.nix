{ config, pkgs, ... }:

{
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = config.sops.secrets.cache-private-key.path;
    bindAddress = "127.0.0.1";
  };

  my.proxy.domains.cache.proxyPass =
    "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
}
