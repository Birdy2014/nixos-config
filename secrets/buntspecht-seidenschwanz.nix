{ config, ... }:

{
  sops = {
    secrets = let file = "/etc/nixos-secrets/buntspecht-seidenschwanz.yaml";
    in {
      frp-token.sopsFile = file;
      "bind-dnskey_seidenschwanz.mvogel.dev".sopsFile = file;
    };

    templates."frp-token.env".content = ''
      FRP_TOKEN=${config.sops.placeholder.frp-token}
    '';

    templates."bind-dnskey.conf" = {
      content = ''
        key "seidenschwanz.mvogel.dev" {
          algorithm hmac-sha256;
          secret "${
            config.sops.placeholder."bind-dnskey_seidenschwanz.mvogel.dev"
          }";
        };
      '';
    };
  };
}
