{ config, lib, ... }:

{
  services.blocky = {
    enable = true;
    settings = {
      ports.dns = 53;

      queryLog = {
        type = "csv";
        target = "/var/log/blocky";
        logRetentionDays = 7;
      };

      upstreams.groups.default = [
        # Cloudflare DoH
        "https://one.one.one.one/dns-query"

        # Cloudflare DoT
        "tcp-tls:2606:4700:4700::1111#one.one.one.one"
        "tcp-tls:1.1.1.1#one.one.one.one"

        # Quad9 DoH
        "https://dns.quad9.net/dns-query"

        # Quad9 DoT
        "tcp-tls:2620:fe::fe#dns.quad9.net"
        "tcp-tls:9.9.9.9#dns.quad9.net"
      ];

      bootstrapDns.upstream = "tcp-tls:1.1.1.1#one.one.one.one";

      caching = {
        minTime = "5m";
        maxTime = "30m";
      };

      blocking = {
        denylists = {
          ads = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
            "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
            "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/pro.txt"
          ];
        };

        allowlists = {
          ads = [
            ''
              s.youtube.com # Youtube Histroy
              s2.youtube.com # Youtube Histroy
              cdn.jsdelivr.net # Breaks some websites
              tagm.tchibo.de # Tchibo Password reset email
              click.discord.com # Für Discord E-Mail Verifikation
            ''
          ];
        };

        clientGroupsBlock = {
          default = [ "ads" ];
        };
      };

      customDNS.mapping =
        (lib.listToAttrs (
          map (name: {
            name = "${name}.seidenschwanz.mvogel.dev";
            value = "fd00:90::10";
          }) (lib.attrNames config.my.proxy.domains)
        ))
        // {
          "seidenschwanz.mvogel.dev" = "fd00:90::10"; # This is not a wildcard because of my patch
          "fritz.box" = "fd00:90::1eed:6fff:fe98:ee7e";
          "rotkehlchen.fritz.box" = "fd00:90::4247:4a9a:1e40:eeb6";
          "rotkehlchen.mvogel.dev" = "fd00:90::4247:4a9a:1e40:eeb6";
        };
    };
  };

  systemd.services.blocky.serviceConfig.LogsDirectory = "blocky";

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
