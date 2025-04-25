{ ... }:

{
  sops.secrets = let file = "/etc/nixos-secrets/buntspecht.yaml";
  in {
    "itf/email-auth" = {
      sopsFile = file;
      owner = "itf";
      group = "itf";
    };

    "itf/email-newsletter" = {
      sopsFile = file;
      owner = "itf";
      group = "itf";
    };

    nextcloud-admin-password = {
      sopsFile = file;
      owner = "nextcloud";
      group = "nextcloud";
    };

    coturn-auth-secret = {
      sopsFile = file;
      # needs to be readable by coturn and synapse
      mode = "0444";
    };
  };
}
