{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  my = {
    desktop.screens = {
      primary = "eDP-1";
      secondary = "HDMI-A-1";
    };
    home.stateVersion = "23.05";
    sshd.enable = true;
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 2;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      splashMode = "normal";
    };
  };

  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelParams = [ "intel_pstate=passive" ];

  networking = {
    networkmanager.enable = true;
    hostName = "zilpzalp";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  services.thermald.enable = true;

  services.tlp.enable = true;

  environment.systemPackages = with pkgs; [ nvtop-intel ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
