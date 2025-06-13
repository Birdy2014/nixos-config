{ ... }:

{
  networking.useDHCP = false;

  systemd.network = {
    enable = true;

    links."10-lan" = {
      matchConfig.PermanentMACAddress = "9c:6b:00:34:4d:e1";
      linkConfig.Name = "lan";
    };

    networks."10-lan" = {
      matchConfig.Name = "lan";
      address = [
        "192.168.90.10/24"
        "fd00:90::10/64"
      ];
      gateway = [
        "192.168.90.1"
        "fe80::1eed:6fff:fe98:ee7e"
      ];

      # defaults to false because IPv6Forwarding is enabled
      networkConfig.IPv6AcceptRA = true;
    };
  };

  networking.nftables.enable = true;

  services.resolved.enable = false;
  networking.resolvconf.useLocalResolver = true;
}
