{
  config,
  myLib,
  pkgs,
  ...
}:

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
          PresharedKeyFile = config.sops.secrets."wireguard/psk12".path;
          AllowedIPs = [ "${myLib.vpnIp6Addr 0}/110" ];
          Endpoint = "mvogel.dev:49626";
          # buntspecht might send a request at any time, so connection must be kept open
          PersistentKeepalive = 25;
        }
      ];
    };

    networks."50-wg-client" = {
      matchConfig.Name = "wg-client";
      address = [ "${myLib.vpnIp6Addr 12}/128" ];
      routes = [ { Destination = "${myLib.vpnIp6Addr 0}/110"; } ];
    };
  };

  networking.nftables.enable = true;

  networking.firewall = {
    extraInputRules = ''
      iifname wg-client ip6 saddr ${myLib.vpnIp6Addr 0}/110 accept
      iifname wg-client drop

      ip6 saddr ${myLib.vpnIp6Addr 0}/110 drop
    '';
  };
}
