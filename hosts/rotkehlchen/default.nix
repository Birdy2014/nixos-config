{ pkgs, pkgsUnstable, ... }:

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
      enable = true;
      stateVersion = "23.05";
      max-volume = 40;
      extraModules = [
        ./home/niri.nix
        ./home/sandboxes.nix
        ./home/ssh.nix
      ];
      mpv.enableExpensiveEffects = true;
    };
    libvirt.enable = true;
    nix.useLocalCache = {
      enable = true;
      prefer = true;
    };
    podman.enable = true;
    programs.neovim.full = true;
    scan.enable = true;
    sshd.enable = false;
    systemd-boot.enable = true;
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
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
    pkgsUnstable.feishin

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

  services.printing.enable = true;

  services.fwupd.enable = true;

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  hardware.amdgpu.initrd.enable = true;

  boot.kernelParams = [
    "amd_pstate=active"

    "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
    "amdgpu.mcbp=0" # This may fix amdgpu crashes?

    # The mitigations have a significant performance impact e.g. in cpu-bound games. (At least on my zen2 cpu)
    "mitigations=off"

    # Disable simpledrm so that the amd gpu is always card0
    # amdgpu must be in initrd!
    # This also causes the screen to be black before amdgpu loads instead of a lower resolution console
    "initcall_blacklist=simpledrm_platform_driver_init"
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

  boot.plymouth = {
    themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "frappe"; }) ];
    theme = "catppuccin-frappe";
  };

  # amd gpu is always card0 when simpledrm is disabled
  boot.kernel.sysfs.class.drm.card0.device.hwmon.hwmon0.power1_cap = 253000000;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
