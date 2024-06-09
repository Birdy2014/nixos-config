{ config, inputs, pkgs, ... }:

let
  itf-config = {
    hostname = "improtheater-frankfurt.de";
    port = 6314;
    tls = true;
    dbpath = "/var/lib/improtheater-frankfurt/improtheater-frankfurt.db";

    email = {
      auth = {
        host = "smtp.strato.de";
        port = 465;
        secure = true;
        user = "accounts@improtheater-frankfurt.de";
        password_file = config.sops.secrets."itf/email-auth".path;
        from =
          "Improtheater Frankfurt accounts <accounts@improtheater-frankfurt.de>";
      };
      itf = {
        host = "smtp.strato.de";
        port = 465;
        secure = true;
        user = "newsletter@improtheater-frankfurt.de";
        password_file = config.sops.secrets."itf/email-newsletter".path;
        from =
          "Improtheater Frankfurt Newsletter <newsletter@improtheater-frankfurt.de>";
      };
      improglycerin = {
        "host" = "smtp.strato.de";
        port = 465;
        secure = true;
        user = "newsletter@improglycerin.de";
        password_file = config.sops.secrets."itf/email-newsletter".path;
        from = "Improglycerin Newsletter <newsletter@improglycerin.de>";
      };
    };
  };

  config-file = pkgs.writeTextFile {
    name = "improtheater-frankfurt-config.json";
    text = builtins.toJSON itf-config;
  };
in {
  users.groups.itf = { };
  users.users.itf = {
    isSystemUser = true;
    group = "itf";
  };

  systemd.services.improtheater-frankfurt = {
    description = "Improtheater Frankfurt website";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      NODE_ENV = "production";
      ITF_CONFIG_FILE = config-file;
    };
    script = "${
        inputs.self.packages.${pkgs.system}.improtheater-frankfurt
      }/bin/improtheater-frankfurt";
    serviceConfig = {
      DynamicUser = true;
      Group = "itf";
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
      StateDirectory = "improtheater-frankfurt";
      SystemCallArchitectures = "native";
      User = "itf";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "${itf-config.hostname}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass =
          "http://${itf-config.hostname}:${builtins.toString itf-config.port}/";
      };

      "www.${itf-config.hostname}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".extraConfig = ''
          return 301 https://${itf-config.hostname}$request_uri;
        '';
      };
    };
  };
}
