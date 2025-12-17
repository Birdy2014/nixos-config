{
  config,
  lib,
  pkgsSelf,
  ...
}:

let
  hostname = "improglycerin.de";
  port = "6315";
in
{
  users.groups.improglycerin = { };
  users.users.improglycerin = {
    isSystemUser = true;
    group = "improglycerin";
  };

  systemd.services.improglycerin = {
    description = "improglycerin website";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    onFailure = [ "notify-failure@%N.service" ];
    startLimitBurst = 3;
    startLimitIntervalSec = 30;
    environment.PORT = port;
    script =
      let
        cache = "/tmp/next-cache-${pkgsSelf.improglycerin.pname}-${pkgsSelf.improglycerin.version}";
      in
      ''
        rm -rf ${cache}
        mkdir -p ${cache}
        ${lib.getExe pkgsSelf.improglycerin}
      '';
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5";

      DynamicUser = true;
      EnvironmentFile = config.sops.templates."improglycerin-yesticket-api-key".path;
      Group = "improglycerin";
      LockPersonality = true;
      PrivateDevices = true;
      PrivateUsers = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "noaccess";
      RestrictNamespaces = true;
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      User = "improglycerin";
    };
  };

  sops.templates."improglycerin-yesticket-api-key" = {
    owner = "improglycerin";
    group = "improglycerin";
    content = ''
      YESTICKET_API_KEY=${config.sops.placeholder.improglycerin-yesticket-api-key}
    '';
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "${hostname}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${port}/";
          recommendedProxySettings = true;
        };
      };

      "www.${hostname}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".extraConfig = ''
          return 301 https://${hostname}$request_uri;
        '';
      };
    };
  };
}
