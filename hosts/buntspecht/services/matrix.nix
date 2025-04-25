{ config, pkgs, ... }:

{
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "mvogel.dev";
      public_baseurl = "https://matrix.mvogel.dev";

      listeners = [{
        bind_addresses = [ "::1" ];
        port = 6167;
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [{
          names = [ "client" "federation" ];
          compress = true;
        }];
      }];

      database.name = "psycopg2";

      # Disable federation
      federation_domain_whitelist = [ ];

      enable_registration = true;
      registration_requires_token = true;

      turn_uris = [ "turn:matrix.mvogel.dev?transport=udp" ];
      turn_shared_secret_path = config.sops.secrets.coturn-auth-secret.path;
    };
  };

  environment.systemPackages = [ pkgs.synadm ];

  services.postgresql.enable = true;

  services.nginx = {
    enable = true;
    virtualHosts = {
      "matrix.mvogel.dev" = let
        proxy = {
          proxyPass = "http://[::1]:6167";
          recommendedProxySettings = true;
        };
      in {
        enableACME = true;
        forceSSL = true;
        locations."/".extraConfig = "return 404;";
        locations."/_matrix" = proxy;
        locations."/_synapse/client" = proxy;
      };
      "mvogel.dev" = let
        mkWellKnown = data: ''
          add_header Content-Type application/json;
          add_header Access-Control-Allow-Origin *;
          return 200 '${builtins.toJSON data}';
        '';
      in {
        locations."/.well-known/matrix/server".extraConfig =
          mkWellKnown { "m.server" = "matrix.mvogel.dev:443"; };
        locations."/.well-known/matrix/client".extraConfig = mkWellKnown {
          "m.homeserver".base_url = "https://matrix.mvogel.dev/";
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
