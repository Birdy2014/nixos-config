{ config, lib, pkgs, ... }:

let cfg = config.my.gaming;
in {
  options.my.gaming.enable = lib.mkEnableOption "gaming related programs";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [ corefonts ];
      remotePlay.openFirewall = true;
    };

    my.bubblewrap = {
      steam = {
        executable = "${pkgs.steam}/bin/steam";
        desktop = "${pkgs.steam}/share/applications/steam.desktop";
        persistentHome = true;
        allowDesktop = true;
        unshareIpc = false;
        extraBinds = [
          "/run/media/moritz/games/Steam-Linux"
          "/run/media/moritz/games/Steam-Images"
          "/sys/class/input"
        ];
        extraDevBinds = (lib.genList (x: "/dev/hidraw${toString x}") 13)
          ++ [ "/dev/input" "/dev/uinput" ];
      };

      prismlauncher = {
        executable = "${pkgs.prismlauncher}/bin/prismlauncher";
        desktop =
          "${pkgs.prismlauncher}/share/applications/org.prismlauncher.PrismLauncher.desktop";
        allowDesktop = true;
        extraBinds = [ "$HOME/.local/share/PrismLauncher" ];
        extraRoBinds = [ "$HOME/Downloads" ];
      };

      heroic = {
        executable = "${pkgs.heroic}/bin/heroic";
        desktop =
          "${pkgs.heroic}/share/applications/com.heroicgameslauncher.hgl.desktop";
        allowDesktop = true;
        persistentHome = true;
        extraBinds = [ "/run/media/moritz/games/Heroic" "/sys/class/input" ];
        extraDevBinds = (lib.genList (x: "/dev/hidraw${toString x}") 13)
          ++ [ "/dev/input" "/dev/uinput" ];
      };
    };

    environment.systemPackages = with pkgs; [
      # Launchers
      heroic
      prismlauncher
      (lutris.override { extraPkgs = pkgs: [ wineWowPackages.stable ]; })

      # Emulators
      dolphin-emu
      rpcs3

      # Tools
      mangohud
    ];

    boot.blacklistedKernelModules = [ "hid_nintendo" ];
  };
}
