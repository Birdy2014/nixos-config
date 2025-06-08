{ pkgs, ... }:

{
  services.nginx.virtualHosts."seidenschwanz.mvogel.dev" = {
    default = true;
    serverName = "seidenschwanz.mvogel.dev";
    onlySSL = true;
    useACMEHost = "seidenschwanz.mvogel.dev";
    listenAddresses = [ "[fd00:90::10]" ];
    locations."/".root = pkgs.runCommand "seidenschwanz-dashboard" { } ''
      mkdir "$out"
      cp ${./dashboard.html} "$out/index.html"
    '';
  };
}
