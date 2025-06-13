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
    };
}
