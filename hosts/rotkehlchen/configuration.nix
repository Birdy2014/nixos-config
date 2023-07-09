{ pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixos-modules/boot.nix
    ../../nixos-modules/nix.nix
    ../../nixos-modules/console.nix
    ../../nixos-modules/user.nix
    ../../nixos-modules/desktop.nix
    ../../nixos-modules/cli-apps.nix
    ../../nixos-modules/gaming.nix
    ../../nixos-modules/virtualisation.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 2;
    grub = {
      enable = true;
      useOSProber = true;
      device = "nodev";
      efiSupport = true;
    };
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

  environment.systemPackages = with pkgs; [ vim ddcutil corectrl sidequest ];

  services.udisks2.enable = true;

  # FIXME: kdeconnect can't find default web browser
  programs.kdeconnect.enable = true;

  programs.adb.enable = true;
  users.users.moritz.extraGroups = [ "adbusers" ];

  # Needed for ddcutil
  hardware.i2c.enable = true;

  # Workaround for Creative Sound BlasterX G6
  systemd.services.soundblaster-reset-usb = {
    script =
      "${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 0x041e -p 0x3256 --reset-usb";
    wantedBy = [ "multi-user.target" ];
    restartIfChanged = false;
  };

  systemd.user.services.soundblaster-set-alsa-options = {
    script = ''
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'PCM Capture Source' 'External Mic'
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'External Mic',0 Capture cap
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'External Mic',0 Capture 9dB
    '';
    preStart = "${pkgs.coreutils-full}/bin/sleep 2";
    wantedBy = [ "pipewire.service" ];
    after = [ "pipewire.service" "wireplumber.service" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
