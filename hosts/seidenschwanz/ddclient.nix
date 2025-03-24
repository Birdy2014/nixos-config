{ config, pkgsUnstable, ... }:

{
  services.ddclient = {
    enable = true;

    # Workaround for https://github.com/ddclient/ddclient/issues/615
    # TODO: Remove with NixOS 25.05
    package = pkgsUnstable.ddclient;

    protocol = "nsupdate";
    server = "ns.mvogel.dev";
    zone = "seidenschwanz.mvogel.dev";
    passwordFile = config.sops.templates."bind-dnskey.conf".path;
    domains = [ "ipv6.seidenschwanz.mvogel.dev" ];
    # ddns for ipv4 is not useful, as seidenschwanz is behind a CGNAT.
    usev4 = "";
    usev6 = "ifv6, ifv6=lan";
  };
}
