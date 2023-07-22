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

  # Workaround for Creative Sound BlasterX G6
  systemd = let
    # Wait until wireplumber has set the alsa options. This takes a while especially after suspend.
    amixerWaitScript = ''
      ${pkgs.coreutils-full}/bin/sleep 10
    '';

    alsaOptionsScript = ''
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'PCM Capture Source' 'External Mic'
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'External Mic',0 Capture cap
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'External Mic',0 Capture 9dB
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'Line In',0 Capture nocap
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'S/PDIF In',0 Capture nocap
      ${pkgs.alsaUtils}/bin/amixer -D hw:G6 sset 'What U Hear',0 Capture nocap
    '';
  in {
    services.soundblaster-reset-usb = {
      script =
        "${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 0x041e -p 0x3256 --reset-usb";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { Type = "oneshot"; };
    };

    user.services.soundblaster-set-alsa-options = {
      script = alsaOptionsScript;
      preStart = amixerWaitScript;
      wantedBy = [ "pipewire.service" ];
      after = [ "pipewire.service" "wireplumber.service" ];
      serviceConfig = { Type = "oneshot"; };
    };

    services.soundblaster-set-alsa-options = {
      script = alsaOptionsScript;
      preStart = amixerWaitScript;
      wantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
      serviceConfig = {
        Type = "oneshot";
        User = "moritz";
        Group = "users";
      };
    };
  };

  boot.extraModprobeConfig = ''
    options snd_usb_audio id=G6 index=0
    options snd_hda_intel id=HDMI,Generic index=1,2 enable=0,0
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
