{ pkgsSelf, config, ... }:

{
  /*
    virtualisation.oci-containers = {
      backend = "podman";
      containers.homeassistant = {
        volumes = [ "/etc/home-assistant:/config" ];
        environment.TZ = config.time.timeZone;
        image = "ghcr.io/home-assistant/home-assistant:stable";
        pull = "always";
        ports = [ "127.0.0.1:8123:8123" ];
        devices = [ "/dev/ttyUSB0:/dev/ttyUSB0" ];
      };
    };
  */

  services.home-assistant = {
    enable = true;
    config = null;
    lovelaceConfig = null;
    configDir = "/etc/home-assistant";
    extraComponents = [
      "default_config"
      /*
        # Components required to complete the onboarding
        "analytics"
        "google_translate"
        "met"
        "radio_browser"
        "shopping_list"
      */
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
      # Zigbee integration
      "zha"
    ];
  };

  my.proxy.domains.ha = {
    proxyPass = "http://localhost:8123";
    proxyWebsockets = true;
  };

  # environment.systemPackages = [ pkgsSelf.lldap-ha-auth ];
}
