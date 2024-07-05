{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./soundblaster.nix
    ./btrbk.nix
    ./kdeconnect.nix
  ];

  my = {
    gaming.enable = true;
    home = {
      stateVersion = "23.05";
      max-volume = 40;
      extraModules = [ ./home/spotify.nix ./home/mpd.nix ];
      mpv.enableExpensiveEffects = true;
    };
    scan.enable = true;
    sshd.enable = false;
    virtualisation.enable = true;
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 2;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      splashMode = "normal";
      gfxmodeEfi = "3440x1440,auto";
      gfxpayloadEfi = "keep";
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.btrfs.autoScrub.enable = true;

  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  environment.systemPackages = with pkgs; [
    ddcutil
    gimp
    vesktop
    signal-desktop
    nvtopPackages.amd
    sops
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

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.fwupd.enable = true;

  services.logind.powerKey = "ignore";

  # mpd
  networking.firewall.allowedTCPPorts = [ 6600 ];

  boot.kernelParams = [
    "amd_pstate=active"
    "amd_prefcore=enable"

    "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
    "amdgpu.mcbp=0" # This may fix amdgpu crashes?

    # The mitigations have a significant performance impact e.g. in cpu-bound games. (At least on my zen2 cpu)
    "mitigations=off"
  ];

  fileSystems."/run/media/moritz/family" = {
    device = "//seidenschwanz.mvogel.dev/family";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts =
        "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in [ "${automount_opts},credentials=/smb-secrets,uid=1000,gid=100" ];
  };

  systemd.services.gpu-power-limit = {
    script = ''
      echo 200000000 > /sys/class/drm/card1/device/hwmon/hwmon0/power1_cap
    '';
    wantedBy = [ "multi-user.target" ];
    serviceConfig = { Type = "oneshot"; };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
