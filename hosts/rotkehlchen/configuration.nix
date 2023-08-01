{ pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./soundblaster.nix
    ../../nixos-modules/boot.nix
    ../../nixos-modules/nix.nix
    ../../nixos-modules/console.nix
    ../../nixos-modules/user.nix
    ../../nixos-modules/desktop.nix
    ../../nixos-modules/cli-apps.nix
    ../../nixos-modules/gaming.nix
    ../../nixos-modules/virtualisation.nix
    ../../nixos-modules/scan.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 2;
    grub = {
      enable = true;
      useOSProber = true;
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

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  environment.systemPackages = with pkgs; [ vim ddcutil corectrl sidequest ];

  services.udisks2.enable = true;

  programs.kdeconnect.enable = true;

  programs.adb.enable = true;
  users.users.moritz.extraGroups = [ "adbusers" ];

  # Needed for ddcutil
  hardware.i2c.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
