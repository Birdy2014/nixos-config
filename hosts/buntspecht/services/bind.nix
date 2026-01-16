{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  services.bind =
    let
      secondary-ns = [
        # ns1.first-ns.de.
        "213.239.242.238"
        "2a01:4f8:0:a101::a:1"

        # robotns2.second-ns.de.
        "213.133.100.103"
        "2a01:4f8:0:1::5ddc:2"

        # robotns3.second-ns.com.
        "193.47.99.3"
        "2001:67c:192c::add:a3"
      ];
    in
    {
      enable = true;

      listenOn = [ "49.13.31.214" ];
      listenOnIpv6 = [ "2a01:4f8:c012:2dfe::1" ];

      extraConfig = ''
        include "${config.sops.templates."bind-dnskey_seidenschwanz.mvogel.dev.conf".path}";
        include "${config.sops.templates."bind-dnskey_mvogel.dev.conf".path}";
      '';

      zones =
        let
          inherit (inputs.dns.util.${pkgs.stdenv.hostPlatform.system}) writeZone;
        in
        {
          "mvogel.dev" =
            with inputs.dns.lib.combinators;
            let
              buntspecht = host "49.13.31.214" "2a01:4f8:c012:2dfe::1";

              zone = {
                SOA = {
                  nameServer = "ns1.mvogel.dev.";
                  adminEmail = "hostmaster.mvogel.dev.";
                  serial = 2026011601;
                };
                NS = [ "ns1.mvogel.dev." ];
                A = [ "49.13.31.214" ];
                AAAA = [ "2a01:4f8:c012:2dfe::1" ];

                MX = lib.genList (n: mx.mx 20 "mxext${toString (n + 1)}.mailbox.org.") 3;

                subdomains = {
                  _dmarc.TXT = [ "v=DMARC1;p=reject;rua=mailto:postmaster@mvogel.dev" ];
                  acme.NS = [ "ns1.mvogel.dev." ];
                  inherit seidenschwanz;
                  matrix = buntspecht;
                  ns1 = buntspecht;
                  ntfy = buntspecht;

                  # Mailbox.org domain validation
                  "5e2bed7815175860fd660611b7b425b13e6c1ab0".TXT = [ "5f22d22753782441345af7c37672250517a9c9bd" ];
                }
                // (
                  lib.genList (n: toString (n + 1)) 4
                  |> lib.flip lib.genAttrs' (
                    n:
                    lib.nameValuePair "mbo000${n}._domainkey" {
                      CNAME = [
                        "MBO000${n}._domainkey.mailbox.org."
                      ];
                    }
                  )
                );
              };

              seidenschwanz = {
                AAAA = [ "2a01:4f8:c012:2dfe:1::2" ];

                subdomains = {
                  "_acme-challenge".CNAME = [ "seidenschwanz.acme.mvogel.dev." ];
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
              extraConfig = ''
                also-notify  { ${lib.concatMapStrings (address: "${address}; ") secondary-ns} };
              '';
              slaves = secondary-ns;
              file = writeZone "mvogel.dev" zone;
            };

          "acme.mvogel.dev" = {
            master = true;
            extraConfig = "allow-update { key seidenschwanz.mvogel.dev.; };";
            file = "/var/db/bind/acme.mvogel.dev";
          };
        };
    };

  sops.templates = {
    "bind-dnskey_mvogel.dev.conf" = {
      # The key name is what hetzner expects
      content = ''
        key "mvogel.dev.2a01:4f8:c012:2dfe::1" {
          algorithm hmac-sha256;
          secret "${config.sops.placeholder."bind-dnskey_mvogel.dev"}";
        };
      '';
      owner = "named";
    };

    "bind-dnskey_seidenschwanz.mvogel.dev.conf" = {
      content = ''
        key "seidenschwanz.mvogel.dev" {
          algorithm hmac-sha256;
          secret "${config.sops.placeholder."bind-dnskey_seidenschwanz.mvogel.dev"}";
        };
      '';
      owner = "named";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  environment.systemPackages = [ pkgs.bind ];
}
