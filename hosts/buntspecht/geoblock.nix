{ pkgs, pkgsSelf, ... }:

{
  systemd = {
    services.geoblock = {
      path = [
        pkgsSelf.geoblock
        pkgs.nftables
      ];
      script = ''
        geoblock ru cn > /tmp/geoblock.nft
        nft destroy table inet geoblock
        nft -f /tmp/geoblock.nft
        rm /tmp/geoblock.nft
      '';
      serviceConfig = {
        PrivateTmp = true;
      };
      after = [ "network.target" ];
      wantedBy = [ "network.target" ];
    };

    timers.geoblock = {
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = "*-*-* 0/12:00:00";
    };
  };
}
