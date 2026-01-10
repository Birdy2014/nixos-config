{ ... }:

{
  sops.secrets =
    let
      file = "/etc/nixos-secrets/haussperling.yaml";
    in
    {
      wpa-supplicant-config.sopsFile = file;

      "wireguard/private-key" = {
        sopsFile = file;
        owner = "systemd-network";
        group = "systemd-network";
      };

      "wireguard/psk11" = {
        sopsFile = file;
        owner = "systemd-network";
        group = "systemd-network";
      };
    };
}
