{ ... }:

{
  sops.secrets =
    let
      file = "/etc/nixos-secrets/zilpzalp.yaml";
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
    };
}
