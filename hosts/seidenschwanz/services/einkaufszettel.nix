{ pkgsSelf, ... }:

let
  address = "127.0.0.1:8097";
in
{
  systemd.services.einkaufszettel = {
    description = "einkaufszettel";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    script = "${pkgsSelf.einkaufszettel}/bin/einkaufszettel ${address} '/var/lib/einkaufszettel/data.json'";
    serviceConfig = {
      CapabilityBoundingSet = "CAP_WAKE_ALARM";
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
      StateDirectory = "einkaufszettel";
      SystemCallArchitectures = "native";
    };
  };

  my.proxy.domains.einkaufszettel.proxyPass = "http://${address}";
}
