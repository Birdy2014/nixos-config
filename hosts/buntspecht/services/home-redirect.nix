{ ... }:

{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "mvogel.dev" = {
        enableACME = true;
        forceSSL = true;
        locations."/".extraConfig = ''
          return 301 https://github.com/Birdy2014;
        '';
      };
    };
  };
}
