{
  config,
  pkgs,
  pkgsSelf,
  ...
}:

let
  hostname = "improtheater-frankfurt.de";

  itf-config = {
    base_url = "https://${hostname}";
    address = "127.0.0.1";
    port = 6314;
    data_directory = "/var/lib/improtheater-frankfurt";

    email = {
      auth = {
        host = "smtp.strato.de";
        port = 465;
        secure = true;
        user = "accounts@improtheater-frankfurt.de";
        password_file = config.sops.secrets."itf/email-auth".path;
        from = "Improtheater Frankfurt accounts <accounts@improtheater-frankfurt.de>";
      };
      itf = {
        host = "smtp.strato.de";
        port = 465;
        secure = true;
        user = "newsletter@improtheater-frankfurt.de";
        password_file = config.sops.secrets."itf/email-newsletter".path;
        from = "Improtheater Frankfurt Newsletter <newsletter@improtheater-frankfurt.de>";
      };
      improglycerin = {
        host = "smtp.strato.de";
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
in
{
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
    script = "${pkgsSelf.improtheater-frankfurt}/bin/improtheater-frankfurt";
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
      "${hostname}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString itf-config.port}/";
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
