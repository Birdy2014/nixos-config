{
  config,
  lib,
  myLib,
  pkgs,
  pkgsSelf,
  pkgsUnstable,
  inputs,
  ...
}:

let
  cfg = config.my.home;
in
{
  options.my.home = {
    enable = lib.mkEnableOption "user 'moritz'";

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

    mpv.enableExpensiveEffects = lib.mkEnableOption "expensive effects in mpv for high video quality.";
  };

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = lib.mkIf config.my.home.enable {
    users.users.moritz = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "i2c"
      ];
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
      extraSpecialArgs = {
        inherit
          inputs
          myLib
          pkgsSelf
          pkgsUnstable
          ;
      };
      users.moritz = {
        imports = [
          ../home
          { home.stateVersion = cfg.stateVersion; }
        ]
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
        value = "-11";
      }
      {
        domain = "moritz";
        item = "nproc";
        type = "-";
        value = "10000";
      }
    ];

    services.resolved.dnsovertls = "opportunistic";

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.swaylock.enable = true;

    # Needed for home-manager configured xdg-desktop-portal
    environment.pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];

    fonts = {
      enableDefaultPackages = true;

      fontDir.enable = true;

      fontconfig = {
        enable = true;

        defaultFonts.serif = [
          "NotoSerif Nerd Font"
          "Noto Serif CJK JP"
        ];
        defaultFonts.sansSerif = [
          "NotoSans Nerd Font"
          "Noto Sans CJK JP"
        ];
        defaultFonts.monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Sans Mono CJK JP"
        ];
        defaultFonts.emoji = [ "Noto Color Emoji" ];
      };

      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.noto
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        corefonts
        vista-fonts
      ];
    };

    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings.main = {
          capslock = "esc";
          rightmeta = "f13";

          # The menu key is "compose", not "menu"
          compose = "f13";

          # Upper mouse side button
          mouse2 = "overload(meta, mouse2)";
        };
      };
    };

    services.syncthing = {
      enable = true;
      user = "moritz";
      group = "users";
      overrideFolders = false;
      overrideDevices = false;
      openDefaultPorts = true;
      configDir = "${config.users.users.moritz.home}/.config/syncthing";
      dataDir = "${config.users.users.moritz.home}/.local/state/syncthing";
    };

    # For accessing SMB shares with `gio mount`
    services.gvfs.enable = true;
    environment.systemPackages = [ pkgs.glib ];
  };
}
