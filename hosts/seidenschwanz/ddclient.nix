{ config, lib, pkgs, ... }:

{
  services.ddclient = {
    enable = true;
    protocol = "dyndns2";
    server = "dynv6.com";
    username = "none";
    passwordFile = config.sops.secrets.ddclient.path;
    domains = [ "seidenschwanz.mvogel.dev" "ipv6.seidenschwanz.mvogel.dev" ]
      ++ (map (name: "${name}.seidenschwanz.mvogel.dev")
        (lib.attrNames config.my.proxy.domains));
    usev4 = "webv4, webv4=https://checkip.dns.he.net/";
    usev6 = "ifv6, ifv6=lan";
  };

  systemd.services.ddclient.path = [ pkgs.iproute2 ];
}
