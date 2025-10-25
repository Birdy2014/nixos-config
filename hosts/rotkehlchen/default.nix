{ pkgs, ... }:

{
  imports = [
    ../../secrets/rotkehlchen.nix
    ./borg.nix
    ./btrbk.nix
    ./filesystems.nix
    ./kdeconnect.nix
    ./network.nix
    ./smb-shares.nix
    ./soundblaster.nix
  ];

  my = {
    desktop = {
      enable = true;
      colorscheme = "catppuccin-frappe";
      compositor = "niri";
    };
    gaming.enable = true;
    home = {
      stateVersion = "23.05";
      max-volume = 40;
      extraModules = [
        ./home/niri.nix
        ./home/sandboxes.nix
        ./home/ssh.nix
      ];
      mpv.enableExpensiveEffects = true;
    };
    scan.enable = true;
    sshd.enable = false;
    systemd-boot.enable = true;
    virtualisation.enable = true;
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.btrfs.autoScrub.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    # CLI
    ddcutil
    nvtopPackages.amd
    sops
    syncplay-nogui

    # GUI
    gimp3
    mcomix

    signal-desktop
    mumble
  ];

  programs.adb.enable = true;
  users.users.moritz.extraGroups = [ "adbusers" ];

  # Needed for ddcutil
  hardware.i2c.enable = true;

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  # Required for openrgb, remove with NixOS 25.11
  nixpkgs.config.permittedInsecurePackages = [
    "mbedtls-2.28.10"
  ];

  services.printing.enable = true;

  services.fwupd.enable = true;

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  boot.kernelParams = [
    "amd_pstate=active"

    "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
    "amdgpu.mcbp=0" # This may fix amdgpu crashes?

    # The mitigations have a significant performance impact e.g. in cpu-bound games. (At least on my zen2 cpu)
    "mitigations=off"
  ];

  boot.kernel.sysctl = {
    # Improve performance in some broken windows games
    "kernel.split_lock_mitigate" = 0;
  };

  services.static-web-server = {
    enable = true;
    listen = "[::]:8787";
    root = "/home/moritz/misc/nighttab-images";
  };

  systemd.services.gpu-power-limit = {
    script = ''
      echo 253000000 > /sys/class/drm/card1/device/hwmon/hwmon0/power1_cap
    '';
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
