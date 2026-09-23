{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.proxy;
  baseDomain = "${config.networking.hostName}.mvogel.dev";
in
{
  options.my.proxy.domains = lib.mkOption {
    description = "Domains to proxy";
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          proxyPass = lib.mkOption {
            type = lib.types.str;
            description = "The target url of the proxy.";
          };
          proxyWebsockets = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "enable proxyWebsockets";
          };
        };
      }
    );
  };

  config = lib.mkIf (cfg.domains != { }) {
    services.nginx = {
      enable = true;

      recommendedTlsSettings = true;
      recommendedOptimisation = true;

      virtualHosts = lib.mapAttrs (domainName: domainConfig: {
        serverName = "${domainName}.${baseDomain}";
        onlySSL = true;
        useACMEHost = baseDomain;
        locations."/" = {
          inherit (domainConfig) proxyPass proxyWebsockets;
          recommendedProxySettings = true;
        };
      }) cfg.domains;
    };

    systemd.services.nginx.serviceConfig.SupplementaryGroups = [ "acme" ];
    systemd.services.nginx-config-reload.serviceConfig.SupplementaryGroups = [ "acme" ];

    networking.firewall.allowedTCPPorts = [ 443 ];

    security.acme.certs.${baseDomain} = {
      extraDomainNames = [ "*.${baseDomain}" ];
      dnsProvider = "rfc2136";
      dnsResolver = "1.1.1.1:53";
      environmentFile = pkgs.writeText "lego-${baseDomain}" ''
        RFC2136_NAMESERVER=ns1.mvogel.dev
        RFC2136_TSIG_ALGORITHM=hmac-sha256.
        RFC2136_TSIG_KEY=${baseDomain}
      '';
      credentialFiles."RFC2136_TSIG_SECRET_FILE" = config.sops.secrets."bind-dnskey_${baseDomain}".path;
    };
  };
}
