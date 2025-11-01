{
  config,
  lib,
  myLib,
  pkgs,
  ...
}:

let
  peers = [
    {
      publicKey = "ShKhJqkATheapke0wOhASBVB+fmd3nO1DjdNKU8C6nw=";
      pskFile = config.sops.secrets."wireguard/psk2".path;
      n = 2;
    }
    {
      publicKey = "9IC9pI03tpeGKk2obXtcHvQ5O63fW06bk4q7l1UhX2Y=";
      pskFile = config.sops.secrets."wireguard/psk6".path;
      n = 6;
    }
    {
      publicKey = "zef1la/06RNbT20ufaL14pinQ421EILNw49Flm5k12U=";
      pskFile = config.sops.secrets."wireguard/psk7".path;
      n = 7;
    }
  ];

  vpnIp6Addr = n: "fd00:90::100:1${myLib.zeroPad 2 (myLib.decToHex n)}";
in
{
  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking.firewall.allowedUDPPorts = [ 49626 ];

  systemd.network = {
    # Required in addition to per-interface IPv6Forwarding
    config.networkConfig.IPv6Forwarding = true;

    netdevs."50-wg-server" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-server";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wireguard/private-key-server".path;
        ListenPort = 49626;
      };
      wireguardPeers =
        (map (
          {
            publicKey,
            pskFile,
            n,
            ...
          }:
          {
            PublicKey = publicKey;
            PresharedKeyFile = lib.mkIf (pskFile != null) pskFile;
            AllowedIPs = [ (vpnIp6Addr n) ];
          }
        ) peers)
        ++ [
          {
            PublicKey = "q8qzjVMDQHbhdw9m//d5iPdiqf1ZYtXY7jpllsaIgkQ=";
            PresharedKeyFile = config.sops.secrets."wireguard/psk1-8".path;
            AllowedIPs = [ "fd00:90::/64" ];
          }
        ];
    };

    networks."50-wg-server" = {
      matchConfig.Name = "wg-server";
      address = [ "${vpnIp6Addr 1}/120" ];
      networkConfig.IPv6Forwarding = true;
      routes = [ { Destination = "fd00:90::/64"; } ];
    };
  };

  networking.nftables.enable = true;
  networking.firewall = {
    extraInputRules = ''
      iifname wg-server ip6 saddr fd00:90::/64 accept
      iifname wg-server drop

      ip6 saddr fd00:90::/64 drop
    '';

    filterForward = true;
    extraForwardRules = ''
      ct state established,related accept

      ip6 daddr fd00:90::/64 accept

      log prefix "not forwarding packet"
    '';
  };
}
