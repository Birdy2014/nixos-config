{ ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "data";
    group = "data";
    guiAddress = "127.0.0.1:8384";
  };

  my.proxy.domains.syncthing.proxyPass = "http://127.0.0.1:8384";

  services.nginx.virtualHosts.syncthing.extraConfig = ''
    # Syncthing uses long polling and shorter timeouts cause error messages in the web Interface.
    # I'm not sure which timeouts have to be adjusted.
    proxy_connect_timeout 75s;
    proxy_read_timeout 75s;
    proxy_send_timeout 75;
  '';
}
