{ config, ... }:

{
  sops = {
    secrets =
      let
        file = "/etc/nixos-secrets/common.yaml";
      in
      {
        ntfy-sender-token.sopsFile = file;
      };
  };
}
