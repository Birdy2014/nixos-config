{ lib, pkgs, ... }:

{
  imports = [ ./filesystems.nix ];

  my = {
    desktop.enable = true;
    nix.useLocalCache.enable = true;
    sshd.enable = true;
    pull-deploy = {
      enable = true;
      notify = true;
      laptopMode = true;
    };
  };

  boot.loader = {
    limine = {
      enable = true;
      biosSupport = true;
      biosDevice = "/dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_19098C806775";
      extraConfig = ''
        quiet: yes
      '';
    };
    timeout = 0;
  };

  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  # remove unnecessary packages installed by services.desktopManager.plasma6.enable
  environment.plasma6.excludePackages = [ pkgs.kdePackages.kwin-x11 ];
  services.orca.enable = false;

  # prevent rebuilding xwayland
  programs.xwayland.package = pkgs.xwayland;

  environment.systemPackages = with pkgs; [
    libreoffice
    firefox
    kdePackages.discover
    bambu-studio

    (pkgs.mpv.override {
      scripts = [ pkgs.mpvScripts.modernx ];
    })
  ];

  services.flatpak.enable = true;

  i18n.defaultLocale = lib.mkForce "de_DE.UTF-8";

  virtualisation.vmVariant = {
    virtualisation = {
      cores = 2;
      memorySize = 4096;
      qemu.options = [ "-vga qxl" ];
    };
    users = {
      users.root.password = "test";
      users.moritz = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        home = "/home/moritz";
        createHome = true;
        password = "test";
      };
    };
    boot.loader.limine.biosDevice = lib.mkForce "/dev/disk/by-id/virtio-root";
  };

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
