{ config, lib, pkgs, inputs, ... }:

let cfg = config.my.home;
in {
  options.my.home = {
    stateVersion = lib.mkOption {
      type = lib.types.str;
      description = lib.mkDoc "Home Manager stateVersion.";
    };

    extraModules = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = lib.mkDoc "Extra home-manager modules.";
    };

    max-volume = lib.mkOption {
      type = lib.types.int;
      default = 100;
      description = lib.mkDoc "The maximum audio playback volume.";
    };
  };

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = {
    users.users.moritz = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "i2c" ];
      shell = pkgs.zsh;
      home = "/home/moritz";
      createHome = true;
    };

    programs.zsh.enable = true;

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = { inherit inputs; };
      users.moritz = {
        imports = [ ../home { home.stateVersion = cfg.stateVersion; } ]
          ++ cfg.extraModules;
      };
    };

    # Useful for audio stuff, podman and RPCS3
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Performance-tuning
    security.pam.loginLimits = [
      {
        domain = "moritz";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "moritz";
        item = "rtprio";
        type = "-";
        value = "95";
      }
      {
        domain = "moritz";
        item = "nice";
        type = "-";
        value = "-19";
      }
      {
        domain = "moritz";
        item = "nproc";
        type = "-";
        value = "unlimited";
      }
    ];
  };
}
