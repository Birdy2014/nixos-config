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
    pull-deploy.enable = true;
    sshd.enable = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/swapfile"; } ];

  nix.settings = {
    max-jobs = 1;
    cores = 1;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  system.stateVersion = "24.05";
}
