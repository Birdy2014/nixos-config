{ config, pkgs, ... }:

{
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
        wireguardPeers = [
          {
            wireguardPeerConfig = {
              PublicKey = "P0Xs1Jfqgy+anFVHTMQfRyPiWjY0oTXEfHqp/RbnMz8=";
              PresharedKeyFile = config.sops.secrets."wireguard/psk2".path;
              AllowedIPs = [ "10.100.0.2" "fd00:100::2" ];
            };
          }
          {
            wireguardPeerConfig = {
              PublicKey = "/dPnjIFXx5+dVWIloVCdrVrNnrQg7nsVoQeedFM982U=";
              PresharedKeyFile = config.sops.secrets."wireguard/psk3".path;
              AllowedIPs = [ "10.100.0.3" "fd00:100::3" ];
            };
          }
          {
            wireguardPeerConfig = {
              PublicKey = "/a07tuiXkhvz2dny3u6y9GdfN/aL3jONxh6/MeWWlXI=";
              AllowedIPs = [ "10.100.0.4" ];
            };
          }
          {
            wireguardPeerConfig = {
              PublicKey = "GRqdpb8pU/q1xABuSm1EIxEXAaDavWRKosoRf4yMXk8=";
              AllowedIPs = [ "10.100.0.5" ];
            };
          }
          {
            wireguardPeerConfig = {
              PublicKey = "AJ5znHncvK516Msh7F7aultWZt01rhIE6PCdD2CW33Q=";
              AllowedIPs = [ "10.100.0.6" ];
            };
          }
          {
            wireguardPeerConfig = {
              PublicKey = "F68/nZVgzZeNMYUONM54EIn8HVwnNpuWuDR9is10nzQ=";
              PresharedKeyFile = config.sops.secrets."wireguard/psk7".path;
              AllowedIPs = [ "10.100.0.7" "fd00:100::7" ];
            };
          }
        ];
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
}
