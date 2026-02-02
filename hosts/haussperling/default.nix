{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    ../../secrets/haussperling.nix
    ./network.nix
  ];

  # necessary for wifi to work
  hardware.enableRedistributableFirmware = true;

  my = {
    pull-deploy = {
      enable = true;
      mainDeployMode = "reboot_on_kernel_change";
    };
    sshd.enable = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
    options = [
      "noatime"
      "nodev"
      "nosuid"
    ];
  };

  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/5dd48a3d-be1d-4a0d-bcb0-94da70fbf60a";
    fsType = "btrfs";
    options = [
      "subvol=backup"
      "noatime"
      "nodev"
      "nosuid"
      "noexec"
    ];
  };

  swapDevices = [ { device = "/swapfile"; } ];

  nix.settings = {
    max-jobs = 1;
    cores = 1;
  };

  services.nixos-pull-deploy.settings.build_remotes = [
    "buildremote@mvogel.dev:46773"
    "local"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  system.stateVersion = "24.05";
}
