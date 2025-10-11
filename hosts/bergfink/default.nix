{ lib, pkgs, ... }:

{
  imports = [ ./filesystems.nix ];

  my = {
    desktop.enable = false;
    sshd.enable = true;
    systemd-boot.enable = true;
    pull-deploy = {
      enable = true;
      notify = true;
      mainDeployMode = "boot";
    };
  };

  xdg = {
    autostart.enable = lib.mkForce true;
    icons.enable = lib.mkForce true;
    mime.enable = lib.mkForce true;
    sounds.enable = lib.mkForce true;
  };

  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  environment.systemPackages = with pkgs; [
    libreoffice
    firefox
    kdePackages.discover
  ];

  services.flatpak.enable = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  system.stateVersion = "25.05";
}
