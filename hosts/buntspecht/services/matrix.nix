{ config, pkgs, ... }:

{
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "mvogel.dev";
      public_baseurl = "https://matrix.mvogel.dev";

      listeners = [
        {
          bind_addresses = [ "::1" ];
          port = 6167;
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [
                "client"
                "federation"
              ];
              compress = true;
            }
          ];
        }
      ];

      database.name = "psycopg2";

      federation_domain_whitelist = [
        "fosn2.de"
        "matrix.tu-darmstadt.de"
      ];

      enable_registration = true;
      registration_requires_token = true;

      turn_uris = [ "turn:matrix.mvogel.dev?transport=udp" ];
      turn_shared_secret_path = config.sops.secrets.coturn-auth-secret.path;

      matrix_rtc.transports = [
        {
          type = "livekit";
          livekit_service_url = "https://matrix.mvogel.dev/livekit/jwt";
        }
      ];
    };
  };

  environment.systemPackages = [ pkgs.synadm ];

  services.postgresql.enable = true;

  services.livekit = {
    enable = true;
    keyFile = config.sops.secrets.livekit-keyfile.path;
    settings = {
      bind_addresses = [ "::1" ];
      rtc.use_external_ip = true;
      room.auto_create = false;
      turn =
        let
          acmeDirectory = config.security.acme.certs."matrix.mvogel.dev".directory;
        in
        {
          enabled = true;
          domain = "matrix.mvogel.dev";
          external_tls = false;
          tls_port = 5350;
          udp_port = 3479;
          cert_file = "${acmeDirectory}/fullchain.pem";
          key_file = "${acmeDirectory}/key.pem";
        };
    };
  };

  services.lk-jwt-service = {
    enable = true;
    livekitUrl = "wss://matrix.mvogel.dev/livekit/sfu";
    keyFile = config.sops.secrets.livekit-keyfile.path;
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "matrix.mvogel.dev" =
        let
          proxy = {
            proxyPass = "http://[::1]:6167";
            recommendedProxySettings = true;
          };
        in
        {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/".extraConfig = "return 404;";
            "/_matrix" = proxy;
            "/_synapse/client" = proxy;
            "/livekit/jwt/" = {
              proxyPass = "http://[::1]:${toString config.services.lk-jwt-service.port}/";
              recommendedProxySettings = true;
            };
            "/livekit/sfu/" = {
              proxyPass = "http://[::1]:${toString config.services.livekit.settings.port}/";
              recommendedProxySettings = true;
              proxyWebsockets = true;
              extraConfig = ''
                proxy_send_timeout 120;
                proxy_read_timeout 120;
                proxy_buffering off;

                proxy_set_header Accept-Encoding gzip;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
              '';
            };
          };
        };
      "mvogel.dev" =
        let
          mkWellKnown = data: ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON data}';
          '';
        in
        {
          locations."/.well-known/matrix/server".extraConfig = mkWellKnown {
            "m.server" = "matrix.mvogel.dev:443";
          };
          locations."/.well-known/matrix/client".extraConfig = mkWellKnown {
            "m.homeserver".base_url = "https://matrix.mvogel.dev/";
            "org.matrix.msc4143.rtc_foci" = [
              {
                type = "livekit";
                livekit_service_url = "https://matrix.mvogel.dev/livekit/jwt";
              }
            ];
          };
        };
    };
  };

  systemd.services.nginx.serviceConfig.SupplementaryGroups = [ "acme" ];
  systemd.services.livekit.serviceConfig.SupplementaryGroups = [ "acme" ];
  security.acme.certs."matrix.mvogel.dev".group = "acme";

  services.coturn = {
    enable = true;
    use-auth-secret = true;
    static-auth-secret-file = config.sops.secrets.coturn-auth-secret.path;
    realm = "matrix.mvogel.dev";
    listening-ips = [
      "49.13.31.214"
      "2a01:4f8:c012:2dfe::1"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      config.services.coturn.listening-port
      config.services.coturn.alt-listening-port
      config.services.coturn.tls-listening-port
      config.services.coturn.alt-tls-listening-port
      config.services.livekit.settings.turn.tls_port
    ];
    allowedUDPPorts = [
      config.services.coturn.listening-port
      config.services.coturn.alt-listening-port
      config.services.coturn.tls-listening-port
      config.services.coturn.alt-tls-listening-port
      config.services.livekit.settings.turn.udp_port
    ];
    allowedUDPPortRanges = [
      # coturn
      {
        from = config.services.coturn.min-port;
        to = config.services.coturn.max-port;
      }

      # livekit
      {
        from = config.services.livekit.settings.rtc.port_range_start;
        to = config.services.livekit.settings.rtc.port_range_end;
      }
    ];
  };
}
