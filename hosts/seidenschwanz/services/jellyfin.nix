{ pkgs, ... }:

{
  boot.kernelParams = [ "i915.enable_guc=3" ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver intel-compute-runtime ];
  };

  services.jellyfin.enable = true;

  # auto-discovery https://jellyfin.org/docs/general/networking/index.html
  networking.firewall.allowedUDPPorts = [ 1900 7359 ];

  my.proxy.domains.jellyfin.proxyPass = "http://127.0.0.1:8096";

  services.nginx.virtualHosts.jellyfin = {
    extraConfig = ''
      ## The default `client_max_body_size` is 10M, this might not be enough for some posters, etc.
      client_max_body_size 20M;
    '';

    locations = {
      # Is this necessary?
      "/".extraConfig = ''
        # Disable buffering when the nginx proxy gets very resource heavy upon streaming
        proxy_buffering off;
      '';

      # Required for jellyfin-mpv-shim
      "/socket" = {
        recommendedProxySettings = true;
        proxyWebsockets = true;
        proxyPass = "http://127.0.0.1:8096";
      };
    };
  };
}
