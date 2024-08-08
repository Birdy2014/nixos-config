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

  boot.blacklistedKernelModules = [ "nouveau" "acer_wmi" ];
  boot.kernelParams = [ "intel_pstate=passive" ];

  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  services.thermald.enable = true;

  services.tlp.enable = true;

  environment.systemPackages = with pkgs; [ nvtopPackages.intel ];

  # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/2669
  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir
      "share/wireplumber/wireplumber.conf.d/10-disable-camera.conf" ''
        wireplumber.profiles = {
          main = {
            monitor.libcamera = disabled
          }
        }
      '')
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
