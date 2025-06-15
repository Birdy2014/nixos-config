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
      wireguardPeers = map (
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
      ) peers;
    };

    networks."50-wg-server" = {
      matchConfig.Name = "wg-server";
      address = [ "${vpnIp6Addr 1}/120" ];
      networkConfig.IPv6Forwarding = true;
    };

    netdevs."50-wg-client" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-client";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wireguard/private-key-client".path;
      };
      wireguardPeers = [
        {
          PublicKey = "YnAMHrnVHWl22Q9Bn4gdWzEs//Z8l83ac5AEdliaD1U=";
          PresharedKeyFile = config.sops.secrets."wireguard/psk1-8".path;
          AllowedIPs = [ "fd00:90::100:100/120" ];
          Endpoint = "mvogel.dev:49626";
          # buntspecht might send a request at any time, so connection must be kept open
          PersistentKeepalive = 25;
        }
      ];
    };

    networks."50-wg-client" = {
      matchConfig.Name = "wg-client";
      address = [ "fd00:90::100:108/128" ];
      networkConfig.IPv6Forwarding = true;
      routes = [ { Destination = "fd00:90::100:100/120"; } ];
    };
  };

  services.ndppd = {
    enable = true;
    # Use method "static" to reserve all adresses in this range
    proxies.lan.rules."${vpnIp6Addr 0}/119".method = "static";
  };

  networking.nftables = {
    enable = true;
    tables.wireguard = {
      family = "inet";
      content = ''
        chain input {
          type filter hook input priority 0; policy accept;

          iifname wg-server ip6 saddr ${vpnIp6Addr 0}/120 accept
          iifname wg-server drop

          iifname wg-client ip6 saddr fd00:90::100:100/120 accept
          iifname wg-client drop

          ip6 saddr ${vpnIp6Addr 0}/119 drop
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
