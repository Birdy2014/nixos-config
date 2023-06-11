{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../nixos-modules/boot.nix
      ../../nixos-modules/nix.nix
      ../../nixos-modules/console.nix
      ../../nixos-modules/user.nix
      ../../nixos-modules/desktop.nix
      ../../nixos-modules/cli-apps.nix
      ../../nixos-modules/gaming.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = 2;
  };

  boot.extraModprobeConfig = "options snd_hda_intel power_save=0";

  services.btrfs.autoScrub.enable = true;

  networking = {
    networkmanager.enable = true;
    hostName = "rotkehlchen";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    vim
    ddcutil
  ];

  services.udisks2.enable = true;

  programs.kdeconnect.enable = true;

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
