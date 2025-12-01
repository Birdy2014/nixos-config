{
  config,
  lib,
  myLib,
  pkgs,
  ...
}:

let
  server-port = 49626;

  peers = [
    # seidenschwanz
    {
      publicKey = "q8qzjVMDQHbhdw9m//d5iPdiqf1ZYtXY7jpllsaIgkQ=";
      pskFile = config.sops.secrets."wireguard/psk2".path;
      n = 2;
    }
    {
      publicKey = "fV4pFC3gytY0x5QR1KokVqhQapbHn68cslyPQaxkAGk=";
      pskFile = config.sops.secrets."wireguard/psk3".path;
      n = 3;
    }
    {
      publicKey = "K6i5rQwz8Yuhv0CDp8PhWPGYIcIjjXQl63G37nUvxGk=";
      pskFile = config.sops.secrets."wireguard/psk4".path;
      n = 4;
    }
  ];

  vpnIp6Addr = n: "2a01:4f8:c012:2dfe:1::${myLib.zeroPad 4 (myLib.decToHex n)}";
in
{
  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking.firewall.allowedUDPPorts = [ server-port ];

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
        ListenPort = server-port;
      };
      wireguardPeers = (
        map (
          {
            publicKey,
            pskFile,
            n,
            ...
          }:
          {
            PublicKey = publicKey;
            PresharedKeyFile = lib.mkIf (pskFile != null) pskFile;
            AllowedIPs = [ "${vpnIp6Addr n}/128" ];
          }
        ) peers
      );
    };

    networks."50-wg-server" = {
      matchConfig.Name = "wg-server";
      address = [ "${vpnIp6Addr 1}/110" ];
      networkConfig.IPv6Forwarding = true;
      routes = [ { Destination = "${vpnIp6Addr 0}/110"; } ];
    };
  };

  networking.nftables.enable = true;
  networking.firewall = {
    extraInputRules = ''
      iifname wg-server ip6 saddr ${vpnIp6Addr 0}/110 accept
      iifname wg-server drop

      ip6 saddr ${vpnIp6Addr 0}/110 drop
    '';

    filterForward = true;
    extraForwardRules = ''
      ct state established,related accept

      define SERVERS = {
        ${vpnIp6Addr 2}/128
      }

      ip6 saddr ${vpnIp6Addr 0}/110 ip6 daddr $SERVERS accept
      ip6 saddr $SERVERS ip6 daddr ${vpnIp6Addr 0}/110 accept

      log prefix "not forwarding packet"
    '';
  };
}
