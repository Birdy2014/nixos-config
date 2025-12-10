{ config, pkgs, ... }:

{
  services.bind = {
    enable = true;

    listenOn = [ "49.13.31.214" ];
    listenOnIpv6 = [ "2a01:4f8:c012:2dfe::1" ];

    extraConfig = ''
      include "${config.sops.templates."bind-dnskey.conf".path}";
    '';

    # TODO: Automatically generate static DNS records in the NixOS configuration.
    #       Maybe this can be done by adding multiple zones?
    #       seidenschwanz.mvogel.dev as static and _acme-challenge.seidenschwanz.mvogel.dev and ipv6.seidenschwanz.mvogel.dev as dynamic?

    zones."seidenschwanz.mvogel.dev" = {
      master = true;
      extraConfig = "allow-update { key seidenschwanz.mvogel.dev.; };";
      file = "/var/db/bind/seidenschwanz.mvogel.dev";
    };
  };

  sops.templates."bind-dnskey.conf".owner = "named";

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  environment.systemPackages = [ pkgs.bind ];
}
