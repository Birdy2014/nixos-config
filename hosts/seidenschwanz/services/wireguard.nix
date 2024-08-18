{ config, lib, myLib, pkgs, ... }:

let
  peers = [
    {
      publicKey = "P0Xs1Jfqgy+anFVHTMQfRyPiWjY0oTXEfHqp/RbnMz8=";
      pskFile = config.sops.secrets."wireguard/psk2".path;
      n = 2;
      allowOutgoing = true;
    }
    {
      publicKey = "/dPnjIFXx5+dVWIloVCdrVrNnrQg7nsVoQeedFM982U=";
      pskFile = config.sops.secrets."wireguard/psk3".path;
      n = 3;
      allowOutgoing = true;
    }
    {
      publicKey = "/a07tuiXkhvz2dny3u6y9GdfN/aL3jONxh6/MeWWlXI=";
      pskFile = config.sops.secrets."wireguard/psk4".path;
      n = 4;
      allowOutgoing = true;
    }
    {
      publicKey = "GRqdpb8pU/q1xABuSm1EIxEXAaDavWRKosoRf4yMXk8=";
      pskFile = config.sops.secrets."wireguard/psk5".path;
      n = 5;
      allowOutgoing = true;
    }
    {
      publicKey = "AJ5znHncvK516Msh7F7aultWZt01rhIE6PCdD2CW33Q=";
      pskFile = null;
      n = 6;
      allowOutgoing = true;
    }
    {
      publicKey = "F68/nZVgzZeNMYUONM54EIn8HVwnNpuWuDR9is10nzQ=";
      pskFile = config.sops.secrets."wireguard/psk7".path;
      n = 7;
      allowOutgoing = false;
    }
  ];

  vpnIp4Addr = n: "10.100.0.${toString n}";
  vpnIp6Addr = n: "fd00:90::100:${myLib.decToHex n}";
in {
  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking.firewall.allowedUDPPorts = [ 49626 ];

  systemd.network = {
    netdevs = {
      "50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets."wireguard/private-key".path;
          ListenPort = 49626;
        };
        wireguardPeers = map ({ publicKey, pskFile, n, ... }: {
          wireguardPeerConfig = {
            PublicKey = publicKey;
            PresharedKeyFile = lib.mkIf (pskFile != null) pskFile;
            AllowedIPs = [ (vpnIp4Addr n) (vpnIp6Addr n) ];
          };
        }) peers;
      };
    };

    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "${vpnIp4Addr 1}/24" "${vpnIp6Addr 1}/120" ];
      networkConfig = {
        IPForward = "yes";
        IPMasquerade = "ipv4";
      };
    };
  };

  services.ndppd = {
    enable = true;
    # Use method "static" to reserve all adresses in this range
    proxies.lan.rules."${vpnIp6Addr 0}/120".method = "static";
  };

  # NAT traversal
  services.frp = {
    enable = true;
    role = "client";
    settings = {
      serverAddr = "mvogel.dev";
      serverPort = 7000;
      auth.token = "{{ .Envs.FRP_TOKEN }}";
      transport.protocol = "kcp";

      proxies = [{
        name = "wireguard";
        type = "udp";
        localIp = "127.0.0.1";
        localPort = 49626;
        remotePort = 49626;
        transport.useEncryption = false;
        transport.useCompression = false;
      }];
    };
  };

  systemd.services.frp.serviceConfig.EnvironmentFile =
    config.sops.templates."frp-token.env".path;

  networking.nftables = {
    enable = true;
    tables.wireguard = {
      family = "inet";
      content = ''
        define ALLOWED_IPSV4 = {
          ${
            lib.concatStringsSep "," (map ({ n, ... }: vpnIp4Addr n)
              (lib.filter ({ allowOutgoing, ... }: allowOutgoing) peers))
          }
        }

        define ALLOWED_IPSV6 = {
          ${
            lib.concatStringsSep "," (map ({ n, ... }: vpnIp6Addr n)
              (lib.filter ({ allowOutgoing, ... }: allowOutgoing) peers))
          }
        }

        define WG_NET_IP4 = ${vpnIp4Addr 0}/24
        define WG_NET_IP6 = ${vpnIp6Addr 0}/120

        chain output {
          type filter hook postrouting priority 0; policy accept;

          iifname wg0 oifname lan ip saddr $ALLOWED_IPSV4 accept
          iifname wg0 oifname lan ip6 saddr $ALLOWED_IPSV6 accept
          iifname wg0 oifname lan ip saddr $WG_NET_IP4 log prefix "forbidden IPv4 wireguard peer tries to connect to outside network: " drop
          iifname wg0 oifname lan ip6 saddr $WG_NET_IP6 log prefix "forbidden IPv6 wireguard peer tries to connect to outside network: " drop
        }

        chain nat {
          type nat hook postrouting priority 100; policy accept;

          iifname wg0 oifname lan ip6 saddr $ALLOWED_IPSV6 ip6 daddr fc00::/7 accept
          iifname wg0 oifname lan ip6 saddr $ALLOWED_IPSV6 masquerade
        }
      '';
    };
  };
}
