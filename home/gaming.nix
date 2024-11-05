{ osConfig, lib, pkgs, pkgsUnstable, ... }:

{
  config = lib.mkIf osConfig.my.gaming.enable {
    my.bubblewrap = {
      steam = {
        applications = [ pkgs.steam ];
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
        applications = [ pkgs.prismlauncher ];
        allowDesktop = true;
        extraBinds = [ "$HOME/.local/share/PrismLauncher" ];
        extraRoBinds = [ "$HOME/Downloads" ];
      };

      heroic = {
        applications = [ pkgsUnstable.heroic ];
        allowDesktop = true;
        persistentHome = true;
        extraBinds = [ "/run/media/moritz/games/Heroic" "/sys/class/input" ];
        extraDevBinds = [ "/dev/input" "/dev/uinput" ];
        extraEnv = {
          LIBVA_DRIVERS_PATH = lib.makeSearchPathOutput "drivers" "lib/dri" [
            pkgsUnstable.mesa
            pkgsUnstable.pkgsi686Linux.mesa
          ];
          LD_LIBRARY_PATH = lib.makeLibraryPath [
            pkgsUnstable.mesa.drivers
            pkgsUnstable.pkgsi686Linux.mesa.drivers
          ];
        };
      };

      lutris = {
        applications = [
          (pkgs.lutris.override {
            extraPkgs = pkgs: [ pkgs.wineWowPackages.stable ];
          })
        ];
        allowDesktop = true;
        extraBinds = [
          "$HOME/.config/lutris"
          "$HOME/.local/share/lutris"
          "$HOME/.cache/lutris"
          "/run/media/moritz/games/lutris"
        ];
      };
    };

    home.packages = with pkgs; [
      # Emulators
      dolphin-emu
      rpcs3

      # Tools
      mangohud
    ];
  };
}
