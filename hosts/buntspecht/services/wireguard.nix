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
      n = 2;
    }
    {
      publicKey = "fV4pFC3gytY0x5QR1KokVqhQapbHn68cslyPQaxkAGk=";
      n = 3;
    }
    {
      publicKey = "K6i5rQwz8Yuhv0CDp8PhWPGYIcIjjXQl63G37nUvxGk=";
      n = 4;
    }
    {
      publicKey = "EXdt+mzhl7+KXRhK8VzITEpULimExU7JMF4h2iSx3Dc=";
      n = 5;
    }
    {
      publicKey = "F8jmIU+pBhA+ppPLbbUWDMAjdOG+MTPeJguU1Kl4knM=";
      n = 6;
    }
    {
      publicKey = "66lTwaXHF5ldqQnbiT6MOPOzCB/maZDfto2DmXv3k1M=";
      n = 7;
    }
    {
      publicKey = "dkIEnQ/3vobv1kZf1J7aVDsDBEHuQgLyfxJjyA3/bi0=";
      n = 8;
    }
    {
      publicKey = "vHY40bUsVYp757N+SrZnThw1MwSsuxxcUP0SxLz3Un4=";
      n = 9;
    }
    {
      publicKey = "CxiiAu2vn0k/zVnuSOMJNEKYmpZI9hlOAtFaJzQIIBA=";
      n = 10;
    }
    {
      publicKey = "EGGBwMhsSTWgjApiwkTftvjX8FVR3lGKQAoKFUsUyjk=";
      n = 11;
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
            n,
            ...
          }:
          {
            PublicKey = publicKey;
            PresharedKeyFile = config.sops.secrets."wireguard/psk${toString n}".path;
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
        ${vpnIp6Addr 2}/128,
        ${vpnIp6Addr 11}/128
      }

      ip6 saddr ${vpnIp6Addr 0}/110 ip6 daddr $SERVERS accept
      ip6 saddr $SERVERS ip6 daddr ${vpnIp6Addr 0}/110 accept

      log prefix "not forwarding packet"
    '';
  };

  sops.secrets =
    peers
    |> lib.filter ({ n, ... }: n != 2) # psk2 is in secrets/buntspecht-seidenschwanz.nix
    |> lib.map ({ n, ... }: "wireguard/psk${toString n}")
    |> lib.flip lib.genAttrs (_: {
      inherit (config.sops.secrets."wireguard/private-key-server") sopsFile owner group;
    });
}
