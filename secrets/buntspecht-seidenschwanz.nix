{ ... }:

{
  sops = {
    secrets =
      let
        file = "/etc/nixos-secrets/buntspecht-seidenschwanz.yaml";
      in
      {
        "bind-dnskey_seidenschwanz.mvogel.dev".sopsFile = file;

        "wireguard/psk2" = {
          sopsFile = file;
          owner = "systemd-network";
          group = "systemd-network";
        };
      };
  };
}
