# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixos-modules
  ];

  my = {
    gaming.enable = false;
    virtualisation.enable = false;
    home.stateVersion = "23.05";
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 2;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      splashMode = "normal";
    };
  };

  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelParams = [ "intel_pstate=passive" ];

  networking = {
    networkmanager.enable = true;
    hostName = "zilpzalp";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  services.thermald.enable = true;

  services.tlp.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.moritz.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDW/ScGgC6eoHVvEKAILBiGSushbr+kz8gLLL9DLQHHuvd/o54AnQvuiZ7MOmmwnakJD3sMXxIyAqx1gZn94i0woATvvVDK+IeakIXl+854y/MVuNf0NjdOGBcrppasqZqZAp1yflXDwqvDhHDtuiNyP/9KOE6I9ysjV63iegP6Weka7bvyspRLeLIRiGJuIt+j6jEQmWevaWndnTuVDBx49VZUfev7t+aRdBbhRUfRb0I2W0aj67P1lvLkzCqtuYk/fzHD30rYu6tnAGs1BJrX2ssRg94cXbMf2K4KeRgofBXGwNaPDTsOGzq4v03THP7abFjoemaXVnTucdjhhG7YKgk4+7nDBFEYhlXtDOdQ/ugF8npY6kkLlvZHVqYh/kOoyV3mh3OROdS/eIMKUSxKEP0FqbUNDzhMltlKEDcf53dFuNYkt8OdAnYw+yp13V+9/xf8l9rttIpGBVfdzb7SA+MX/hfjAprs4/3qXqXJ5f2oHh/QfvHp8dOPaGpKEic= moritz@Rotkehlchen-2020-04-15"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

