{ ... }:

{
  networking.useDHCP = false;

  systemd.network = {
    enable = true;

    links."10-wan0" = {
      matchConfig.PermanentMACAddress = "96:00:02:50:b4:7b";
      linkConfig.Name = "wan0";
    };

    networks."10-wan0" = {
      matchConfig.Name = "wan0";
      address = [
        "49.13.31.214/32"
        "2a01:4f8:c012:2dfe::1/64"
        "fe80::9400:2ff:fe50:b47b/64"
      ];
      routes = [
        { routeConfig.Gateway = "fe80::1"; }
        {
          routeConfig = {
            Gateway = "172.31.1.1";
            GatewayOnLink = true;
          };
        }
      ];
    };
  };
}
