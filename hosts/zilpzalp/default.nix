{ pkgs, ... }:

{
  imports = [ ./filesystems.nix ];

  my = {
    desktop.screens = {
      primary = "eDP-1";
      secondary = "HDMI-A-1";
    };
    home.stateVersion = "23.05";
    sshd.enable = true;
    systemd-boot.enable = true;
  };

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.swraid.enable = false;
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics.extraPackages = with pkgs; [ vaapiIntel ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.blacklistedKernelModules = [ "nouveau" "acer_wmi" ];
  boot.kernelParams = [ "intel_pstate=passive" ];

  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  services.thermald.enable = true;

  services.tlp.enable = true;

  environment.systemPackages = with pkgs; [ nvtopPackages.intel ];

  services.tailscale.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
