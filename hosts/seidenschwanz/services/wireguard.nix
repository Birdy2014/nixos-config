{
  config,
  myLib,
  pkgs,
  ...
}:

let
  vpnIp6Addr = n: "2a01:4f8:c012:2dfe:1::${myLib.zeroPad 4 (myLib.decToHex n)}";
in
{
  environment.systemPackages = [ pkgs.wireguard-tools ];

  systemd.network = {
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
          PresharedKeyFile = config.sops.secrets."wireguard/psk2".path;
          AllowedIPs = [ "${vpnIp6Addr 0}/110" ];
          Endpoint = "mvogel.dev:49626";
          # buntspecht might send a request at any time, so connection must be kept open
          PersistentKeepalive = 25;
        }
      ];
    };

    networks."50-wg-client" = {
      matchConfig.Name = "wg-client";
      address = [ "${vpnIp6Addr 2}/128" ];
      routes = [ { Destination = "${vpnIp6Addr 0}/110"; } ];
    };
  };

  networking.firewall = {
    extraInputRules = ''
      iifname wg-client ip6 saddr ${vpnIp6Addr 0}/110 accept
      iifname wg-client drop

      ip6 saddr ${vpnIp6Addr 0}/110 drop
    '';
  };
}
