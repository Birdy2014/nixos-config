{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./soundblaster.nix
    ../../nixos-modules
    ./btrbk.nix
  ];

  my = {
    gaming.enable = true;
    scan.enable = true;
    virtualisation.enable = true;
    home = {
      stateVersion = "23.05";
      max-volume = 40;
      mpdListenExternal = true;
      extraModules = [ ./home/spotify.nix ];
    };
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

  services.btrfs.autoScrub.enable = true;

  networking = {
    networkmanager.enable = true;
    hostName = "rotkehlchen";
  };

  environment.systemPackages = with pkgs; [
    ddcutil
    corectrl
    sidequest
    gimp
    discord
    signal-desktop
  ];

  programs.kdeconnect.enable = true;

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

  boot.kernelParams = [ "amd_pstate=active" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
