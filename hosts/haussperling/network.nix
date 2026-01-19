{
  config,
  lib,
  myLib,
  pkgs,
  ...
}:

let
  vpnIp6Addr = n: "2a01:4f8:c012:2dfe:1::${myLib.zeroPad 4 (myLib.decToHex n)}";
in
{
  networking.useDHCP = false;

  systemd.network = {
    enable = true;

    links."10-wlan" = {
      matchConfig.Type = "wlan";
      linkConfig.Name = "wlan";
    };

    networks."10-default" = {
      matchConfig.Type = [
        "ether"
        "wlan"
      ];
      DHCP = "yes";
      networkConfig.IPv6PrivacyExtensions = true;
    };

    netdevs."50-wg" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wireguard/private-key".path;
      };
      wireguardPeers = [
        {
          PublicKey = "YnAMHrnVHWl22Q9Bn4gdWzEs//Z8l83ac5AEdliaD1U=";
          PresharedKeyFile = config.sops.secrets."wireguard/psk11".path;
          AllowedIPs = [ "${vpnIp6Addr 0}/110" ];
          Endpoint = "mvogel.dev:49626";
          # buntspecht might send a request at any time, so connection must be kept open
          PersistentKeepalive = 25;
        }
      ];
    };

    networks."50-wg" = {
      matchConfig.Name = "wg";
      address = [ "${vpnIp6Addr 11}/128" ];
      routes = [ { Destination = "${vpnIp6Addr 0}/110"; } ];
    };
  };

  services.resolved.enable = true;
  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking.wireless = {
    enable = true;
    interfaces = [ "wlan" ];
  };

  systemd.services.wpa_supplicant-wlan = {
    script = lib.mkForce ''
      wpa_supplicant -iwlan -c${config.sops.secrets."wpa-supplicant-config".path}
    '';
    serviceConfig.Restart = "always";
  };
}
