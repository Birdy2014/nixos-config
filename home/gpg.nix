{ config, ... }:

{
  imports = [ ./xdg.nix ];

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSshSupport = true;
    defaultCacheTtl = 3600;
    maxCacheTtl = 36000;
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
}
