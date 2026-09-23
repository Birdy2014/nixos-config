{ config, ... }:

{
  services.immich = {
    enable = true;
    port = 2283;
    mediaLocation = "/zpool/encrypted/immich";
  };

  # TODO (NixOS 26.11): Remove when updated
  nixpkgs.config.permittedInsecurePackages = [
    "immich-2.7.5"
  ];

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  my.proxy.domains.immich = {
    proxyPass = with config.services.immich; "http://${host}:${toString port}";
    proxyWebsockets = true;
  };

  services.nginx.virtualHosts.immich.extraConfig = ''
    client_max_body_size 50000M;
  '';
}
