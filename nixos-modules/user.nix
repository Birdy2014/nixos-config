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
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useUserPackages = true;
      home-manager.useGlobalPkgs = true;
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.moritz = {
        imports = [ ../home { home.stateVersion = cfg.stateVersion; } ]
          ++ cfg.extraModules;
      };
    }
  ];

  config = {
    users.users.moritz = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "i2c" ];
      shell = pkgs.zsh;
      home = "/home/moritz";
      createHome = true;
    };

    programs.zsh.enable = true;

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
