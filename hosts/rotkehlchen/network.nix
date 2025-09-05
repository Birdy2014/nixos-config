{ ... }:

{
  networking.useDHCP = false;

  systemd.network = {
    enable = true;

    links."10-lan" = {
      matchConfig.PermanentMACAddress = "00:d8:61:35:00:ba";
      linkConfig.Name = "lan";
    };

    networks."10-lan" = {
      matchConfig.Name = "lan";
      address = [
        "192.168.90.21/24"
        "fd00:90::21/64"
      ];
      gateway = [
        "192.168.90.1"
        "fe80::1eed:6fff:fe98:ee7e"
      ];
      domains = [ "fritz.box" ];
      dns = [
        "fd00:90::10#seidenschwanz.mvogel.dev"
        "192.168.90.10#seidenschwanz.mvogel.dev"
      ];
      networkConfig = {
        DNSOverTLS = true;
        IPv6PrivacyExtensions = true;
        MulticastDNS = true;
      };
    };
  };

  services.resolved.enable = true;
}
