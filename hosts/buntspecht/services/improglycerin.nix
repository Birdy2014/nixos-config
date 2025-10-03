{ lib, pkgsSelf, ... }:

let
  hostname = "neu.improglycerin.de";
  port = "6315";
in
{
  users.groups.itf = { };
  users.users.itf = {
    isSystemUser = true;
    group = "itf";
  };

  systemd.services.improglycerin = {
    description = "improglycerin website";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment.PORT = port;
    script = lib.getExe pkgsSelf.improglycerin;
    serviceConfig = {
      DynamicUser = true;
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
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "${hostname}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/robots.txt".return = "200 'User-agent: *\\nDisallow: /\\n'";
          "/" = {
            proxyPass = "http://127.0.0.1:${port}/";
            recommendedProxySettings = true;
          };
        };
      };
    };
  };
}
