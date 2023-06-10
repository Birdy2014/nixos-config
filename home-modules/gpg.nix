{ config, ... }:

{
  imports = [
    ./xdg.nix
  ];

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
    enableSshSupport = true;
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
}
