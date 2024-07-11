{ config, lib, pkgs, inputs, ... }:

let cfg = config.my.home;
in {
  options.my.home = {
    stateVersion = lib.mkOption {
      type = lib.types.str;
      description = "Home Manager stateVersion.";
    };

    extraModules = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = "Extra home-manager modules.";
    };

    max-volume = lib.mkOption {
      type = lib.types.int;
      default = 100;
      description = "The maximum audio playback volume.";
    };

    mpv.enableExpensiveEffects =
      lib.mkEnableOption "expensive effects in mpv for high video quality.";
  };

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = lib.mkIf config.my.desktop.enable {
    users.users.moritz = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "i2c" ];
      shell = pkgs.zsh;
      # Needed because zsh is not enabled globally to prevent issues with
      # duplicate completion settings in system and home-manager configuration
      ignoreShellProgramCheck = true;
      home = "/home/moritz";
      createHome = true;
    };

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
