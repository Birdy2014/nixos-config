{ config, pkgs, ... }:

{
  services.matrix-conduit = {
    enable = true;
    package = pkgs.conduwuit;
    settings.global = {
      address = "::1";
      port = 6167;
      server_name = "mvogel.dev";
      database_backend = "rocksdb";
      allow_encryption = true;
      allow_federation = true;
      new_user_displayname_suffix = "";

      # TODO: Use turn_secret_file with conduwuit 0.5.0
      #       The turn secret is currently defined in my private config

      turn_uris = [ "turn:matrix.mvogel.dev?transport=udp" ];

      well_known = {
        client = "https://matrix.mvogel.dev";
        server = "matrix.mvogel.dev:443";
      };
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "matrix.mvogel.dev" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://[::1]:6167";
          recommendedProxySettings = true;
        };
      };
      "mvogel.dev" = {
        locations."/.well-known/matrix/" = {
          proxyPass = "http://[::1]:6167";
          recommendedProxySettings = true;
        };
      };
    };
  };

  services.coturn = {
    enable = true;
    use-auth-secret = true;
    static-auth-secret-file = config.sops.secrets.coturn-auth-secret.path;
    realm = "matrix.mvogel.dev";
  };

  networking.firewall.allowedTCPPorts = [ 3478 5349 5349 5350 ];
  networking.firewall.allowedUDPPorts = [ 3478 5349 5349 5350 ];
  networking.firewall.allowedUDPPortRanges = [{
    from = 49152;
    to = 65535;
  }];
}
