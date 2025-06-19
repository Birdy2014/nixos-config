{ pkgs, ... }:

{
  services.nginx.virtualHosts."seidenschwanz.mvogel.dev" = {
    default = true;
    serverName = "seidenschwanz.mvogel.dev";
    onlySSL = true;
    useACMEHost = "seidenschwanz.mvogel.dev";
    listenAddresses = [ "[fd00:90::10]" ];
    locations."/".root =
      let
        dashboard-icons = pkgs.fetchFromGitHub {
          owner = "homarr-labs";
          repo = "dashboard-icons";
          rev = "d508f3708c27c492879aeed981daece06ce451d4";
          hash = "sha256-XviHDJIv+HhFHb18kNPYF1lLTk2IhxvvYayz0dZ4NWA=";
          sparseCheckout = [ "svg" ];
        };
      in
      pkgs.runCommand "seidenschwanz-dashboard" { } ''
        mkdir "$out"
        cp ${./dashboard.html} "$out/index.html"
        cp -r ${dashboard-icons}/svg "$out"
      '';
  };
}
