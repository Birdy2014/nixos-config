{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f313ecbb-7133-4a4e-bf77-272570e8a286";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd:1" ];
  };

  boot.initrd.luks.devices."nixos-root".device =
    "/dev/disk/by-uuid/ec1f1df4-349f-43ca-aa22-8c60a5845a5a";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/f313ecbb-7133-4a4e-bf77-272570e8a286";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd:1" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/f313ecbb-7133-4a4e-bf77-272570e8a286";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd:1" "noatime" ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/f313ecbb-7133-4a4e-bf77-272570e8a286";
    fsType = "btrfs";
    options = [ "subvol=swap" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1820-B211";
    fsType = "vfat";
  };

  fileSystems."/run/media/moritz/1TBSSD" = {
    device = "/dev/disk/by-uuid/06113bad-6b63-4c3c-9816-998ec6b0a994";
    fsType = "ext4";
  };

  fileSystems."/run/media/moritz/1TBHDD" = {
    device = "/dev/disk/by-uuid/07f200d9-153b-4396-a6e6-cf208a154435";
    fsType = "ext4";
  };

  swapDevices = [{ device = "/swap/swapfile"; }];

  boot.resumeDevice = "/dev/mapper/nixos-root";
  boot.kernelParams = [ "resume_offset=533760" ];

  services.fstrim.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp34s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl.extraPackages = [ pkgs.amdvlk ];
  hardware.opengl.extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  environment.variables.AMD_VULKAN_ICD = "RADV";
}
