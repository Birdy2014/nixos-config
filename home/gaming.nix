{ osConfig, lib, pkgs, pkgsUnstable, ... }:

{
  config = lib.mkIf osConfig.my.gaming.enable {
    my.bubblewrap = {
      steam = {
        applications = [{
          executable = "${pkgs.steam}/bin/steam";
          desktop = "${pkgs.steam}/share/applications/steam.desktop";
        }];
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
        applications = [{
          executable = "${pkgs.prismlauncher}/bin/prismlauncher";
          desktop =
            "${pkgs.prismlauncher}/share/applications/org.prismlauncher.PrismLauncher.desktop";
        }];
        allowDesktop = true;
        extraBinds = [ "$HOME/.local/share/PrismLauncher" ];
        extraRoBinds = [ "$HOME/Downloads" ];
      };

      heroic = {
        applications = [{
          executable = "${pkgsUnstable.heroic}/bin/heroic";
          desktop =
            "${pkgsUnstable.heroic}/share/applications/com.heroicgameslauncher.hgl.desktop";
        }];
        allowDesktop = true;
        persistentHome = true;
        extraBinds = [ "/run/media/moritz/games/Heroic" "/sys/class/input" ];
        extraDevBinds = [ "/dev/input" "/dev/uinput" ];
        useUnstableMesa = true;
      };
    };

    home.packages = with pkgs; [
      # Launchers
      prismlauncher
      (lutris.override { extraPkgs = pkgs: [ wineWowPackages.stable ]; })

      # Emulators
      dolphin-emu
      rpcs3

      # Tools
      mangohud
    ];
  };
}
