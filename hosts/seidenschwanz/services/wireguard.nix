{ config, lib, pkgs, ... }:

let
  peers = [
    {
      publicKey = "P0Xs1Jfqgy+anFVHTMQfRyPiWjY0oTXEfHqp/RbnMz8=";
      pskFile = config.sops.secrets."wireguard/psk2".path;
      ipv4 = "10.100.0.2";
      ipv6 = "fd00:100::2";
      allowNat = true;
    }
    {
      publicKey = "/dPnjIFXx5+dVWIloVCdrVrNnrQg7nsVoQeedFM982U=";
      pskFile = config.sops.secrets."wireguard/psk3".path;
      ipv4 = "10.100.0.3";
      ipv6 = "fd00:100::3";
      allowNat = true;
    }
    {
      publicKey = "/a07tuiXkhvz2dny3u6y9GdfN/aL3jONxh6/MeWWlXI=";
      pskFile = null;
      ipv4 = "10.100.0.4";
      ipv6 = "fd00:100::4";
      allowNat = true;
    }
    {
      publicKey = "GRqdpb8pU/q1xABuSm1EIxEXAaDavWRKosoRf4yMXk8=";
      pskFile = null;
      ipv4 = "10.100.0.5";
      ipv6 = "fd00:100::5";
      allowNat = true;
    }
    {
      publicKey = "AJ5znHncvK516Msh7F7aultWZt01rhIE6PCdD2CW33Q=";
      pskFile = null;
      ipv4 = "10.100.0.6";
      ipv6 = "fd00:100::6";
      allowNat = true;
    }
    {
      publicKey = "F68/nZVgzZeNMYUONM54EIn8HVwnNpuWuDR9is10nzQ=";
      pskFile = config.sops.secrets."wireguard/psk7".path;
      ipv4 = "10.100.0.7";
      ipv6 = "fd00:100::7";
      allowNat = false;
    }
  ];
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
        wireguardPeers = map ({ publicKey, pskFile, ipv4, ipv6, ... }: {
          wireguardPeerConfig = {
            PublicKey = publicKey;
            PresharedKeyFile = lib.mkIf (pskFile != null) pskFile;
            AllowedIPs = [ ipv4 ipv6 ];
          };
        }) peers;
      };
    };

    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "10.100.0.1/24" "fd00:100::1/64" ];
      networkConfig.IPMasquerade = "both";
    };
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
    tables.wireguard-nat = {
      family = "inet";
      content = ''
        define ALLOWED_IPSV4 = {
          ${
            lib.concatStringsSep "," (map ({ ipv4, ... }: ipv4)
              (lib.filter ({ allowNat, ... }: allowNat) peers))
          }
        }

        define ALLOWED_IPSV6 = {
          ${
            lib.concatStringsSep "," (map ({ ipv6, ... }: ipv6)
              (lib.filter ({ allowNat, ... }: allowNat) peers))
          }
        }

        define WG_NET_IP4 = 10.100.0.0/24
        define WG_NET_IP6 = fd00:100::/64

        chain output {
          type filter hook postrouting priority 0; policy accept;

          iifname wg0 oifname lan ip saddr $ALLOWED_IPSV4 accept
          iifname wg0 oifname lan ip6 saddr $ALLOWED_IPSV6 accept
          iifname wg0 oifname lan ip saddr $WG_NET_IP4 log prefix "forbidden IPv4 wireguard peer tries to nat: " drop
          iifname wg0 oifname lan ip6 saddr $WG_NET_IP6 log prefix "forbidden IPv6 wireguard peer tries to nat: " drop
        }
      '';
    };
  };
}
