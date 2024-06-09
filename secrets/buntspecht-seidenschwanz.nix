{ config, ... }:

{
  sops = {
    secrets = let file = "/etc/nixos-secrets/buntspecht-seidenschwanz.yaml";
    in { frp-token.sopsFile = file; };

    templates."frp-token.env".content = ''
      FRP_TOKEN=${config.sops.placeholder.frp-token}
    '';
  };
}
