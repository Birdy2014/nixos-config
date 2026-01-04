{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  services.bind = {
    enable = true;

    listenOn = [ "49.13.31.214" ];
    listenOnIpv6 = [ "2a01:4f8:c012:2dfe::1" ];

    extraConfig = ''
      include "${config.sops.templates."bind-dnskey.conf".path}";
    '';

    zones."seidenschwanz.mvogel.dev" =
      let
        zone-seidenschwanz = with inputs.dns.lib.combinators; {
          SOA = {
            nameServer = "ns1.mvogel.dev";
            adminEmail = "hostmaster.mvogel.dev";
            serial = 2025122200;
          };
          NS = [ "ns1.mvogel.dev." ];
          AAAA = [ "2a01:4f8:c012:2dfe:1::2" ];
          CAA = letsEncrypt "moritzv7@gmail.com";

          subdomains = {
            "_acme-challenge".CNAME = [ "seidenschwanz.acme.mvogel.dev" ];
          }
          // (
            lib.attrNames inputs.self.nixosConfigurations.seidenschwanz.config.my.proxy.domains
            |> lib.flip lib.genAttrs (_: {
              AAAA = [ "2a01:4f8:c012:2dfe:1::2" ];
            })
          );
        };
      in
      {
        master = true;
        file =
          inputs.dns.util.${pkgs.stdenv.hostPlatform.system}.writeZone "seidenschwanz.mvogel.dev"
            zone-seidenschwanz;
      };

    zones."acme.mvogel.dev" = {
      master = true;
      extraConfig = "allow-update { key seidenschwanz.mvogel.dev.; };";
      file = "/var/db/bind/acme.mvogel.dev";
    };
  };

  sops.templates."bind-dnskey.conf".owner = "named";

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  environment.systemPackages = [ pkgs.bind ];
}
