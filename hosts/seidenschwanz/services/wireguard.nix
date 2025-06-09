{ config, lib, myLib, pkgs, ... }:

let
  peers = [
    {
      publicKey = "P0Xs1Jfqgy+anFVHTMQfRyPiWjY0oTXEfHqp/RbnMz8=";
      pskFile = config.sops.secrets."wireguard/psk2".path;
      n = 2;
    }
    {
      publicKey = "/dPnjIFXx5+dVWIloVCdrVrNnrQg7nsVoQeedFM982U=";
      pskFile = config.sops.secrets."wireguard/psk3".path;
      n = 3;
    }
    {
      publicKey = "/a07tuiXkhvz2dny3u6y9GdfN/aL3jONxh6/MeWWlXI=";
      pskFile = config.sops.secrets."wireguard/psk4".path;
      n = 4;
    }
    {
      publicKey = "GRqdpb8pU/q1xABuSm1EIxEXAaDavWRKosoRf4yMXk8=";
      pskFile = config.sops.secrets."wireguard/psk5".path;
      n = 5;
    }
    {
      publicKey = "AJ5znHncvK516Msh7F7aultWZt01rhIE6PCdD2CW33Q=";
      pskFile = null;
      n = 6;
    }
    {
      publicKey = "F68/nZVgzZeNMYUONM54EIn8HVwnNpuWuDR9is10nzQ=";
      pskFile = config.sops.secrets."wireguard/psk7".path;
      n = 7;
    }
  ];

  vpnIp6Addr = n: "fd00:90::100:${myLib.decToHex n}";
in {
  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking.firewall.allowedUDPPorts = [ 49626 ];

  systemd.network = {
    # Required in addition to per-interface IPv6Forwarding
    config.networkConfig.IPv6Forwarding = true;

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wireguard/private-key".path;
        ListenPort = 49626;
      };
      wireguardPeers = map ({ publicKey, pskFile, n, ... }: {
        PublicKey = publicKey;
        PresharedKeyFile = lib.mkIf (pskFile != null) pskFile;
        AllowedIPs = [ (vpnIp6Addr n) ];
      }) peers;
    };

    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "${vpnIp6Addr 1}/120" ];
      networkConfig.IPv6Forwarding = true;
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
        chain input {
          type filter hook input priority 0; policy accept;

          iifname wg0 ip6 saddr ${vpnIp6Addr 0}/120 accept
          iifname wg0 drop

          iifname lan ip6 saddr ${vpnIp6Addr 0}/120 drop
        }

        chain forward {
          type filter hook forward priority 0; policy drop;

          ct state established,related accept

          ip6 daddr fd00:90::/64 accept

          log prefix "not forwarding packet"
        }
      '';
    };
  };
}
