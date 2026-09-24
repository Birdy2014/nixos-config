{ ... }:

{
  sops.age.keyFile = "/home/moritz/.config/sops/age/keys.txt";

  sops.secrets =
    let
      file = "/etc/nixos-secrets/rotkehlchen.yaml";
    in
    {
      borgbackup-home-key = {
        sopsFile = file;
        owner = "moritz";
        group = "users";
      };

      borgbackup-home-password = {
        sopsFile = file;
        owner = "moritz";
        group = "users";
      };

      seidenschwanz-smb-password.sopsFile = file;

      "wireguard/private-key-client" = {
        sopsFile = file;
        owner = "systemd-network";
        group = "systemd-network";
      };

      "wireguard/psk12" = {
        sopsFile = file;
        owner = "systemd-network";
        group = "systemd-network";
      };

      "bind-dnskey_rotkehlchen.mvogel.dev".sopsFile = file;

      "open-webui-secrets".sopsFile = file;
    };
}
