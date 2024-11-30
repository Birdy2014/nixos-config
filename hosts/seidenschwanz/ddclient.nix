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
    usev4 = "web, web=checkip.dyndns.org";
    usev6 = "ifv6, if=lan";
  };

  systemd.services.ddclient.path = [ pkgs.iproute2 ];
}
