{ config, ... }:

{
  networking.firewall.allowedUDPPorts = [
    7000
    49626
  ];

  services.frp = {
    enable = true;
    role = "server";
    settings = {
      kcpBindPort = 7000;
      auth.token = "{{ .Envs.FRP_TOKEN }}";
      allowPorts = [ { single = 49626; } ];
    };
  };

  systemd.services.frp.serviceConfig.EnvironmentFile = config.sops.templates."frp-token.env".path;
}
