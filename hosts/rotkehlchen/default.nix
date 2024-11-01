{ lib, pkgs, pkgsUnstable, ... }:

{
  imports = [
    ../../secrets/rotkehlchen.nix
    ./borg.nix
    ./btrbk.nix
    ./hardware-configuration.nix
    ./kdeconnect.nix
    ./network.nix
    ./smb-shares.nix
    ./soundblaster.nix
  ];

  my = {
    desktop.colorscheme = "catppuccin-frappe";
    gaming.enable = true;
    home = {
      stateVersion = "23.05";
      max-volume = 40;
      extraModules = [ ./home/spotify.nix ./home/mpd.nix ];
      mpv.enableExpensiveEffects = true;
    };
    scan.enable = true;
    sshd.enable = false;
    systemd-boot.enable = true;
    virtualisation.enable = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.btrfs.autoScrub.enable = true;

  hardware.bluetooth.enable = true;

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

  services.fwupd.enable = true;

  services.logind.powerKey = "ignore";

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  home-manager.users.moritz.my.bubblewrap.feishin = {
    applications = [ pkgsUnstable.feishin ];
    allowDesktop = true;
    extraBinds = [ "$HOME/.config/feishin" ];
    extraEnv.LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgsUnstable.mesa.drivers
      pkgsUnstable.pkgsi686Linux.mesa.drivers
    ];
  };

  # mpd
  networking.firewall.allowedTCPPorts = [ 6600 ];

  boot.kernelParams = [
    "amd_pstate=active"

    "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
    "amdgpu.mcbp=0" # This may fix amdgpu crashes?

    # The mitigations have a significant performance impact e.g. in cpu-bound games. (At least on my zen2 cpu)
    "mitigations=off"
  ];

  services.static-web-server = {
    enable = true;
    listen = "[::]:8787";
    root = "/home/moritz/misc/nighttab-images";
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
