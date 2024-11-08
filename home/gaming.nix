{ osConfig, lib, pkgs, pkgsUnstable, ... }:

{
  config = lib.mkIf osConfig.my.gaming.enable {
    my.bubblewrap = {
      steam = {
        applications = [ pkgs.steam ];
        persistentHome = true;
        allowDesktop = true;
        allowX11 = true;
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
        allowX11 = true;
        extraBinds = [ "$HOME/.local/share/PrismLauncher" ];
        extraRoBinds = [ "$HOME/Downloads" ];
      };

      heroic = {
        applications = [ pkgsUnstable.heroic ];
        allowDesktop = true;
        allowX11 = true;
        persistentHome = true;
        extraBinds = [ "/run/media/moritz/games/Heroic" "/sys/class/input" ];
        extraDevBinds = [ "/dev/input" "/dev/uinput" ];
        customMesaPkgsSet = pkgsUnstable;
      };

      lutris = {
        applications = [
          (pkgs.lutris.override {
            extraPkgs = pkgs: [ pkgs.wineWowPackages.stable ];
          })
        ];
        allowDesktop = true;
        allowX11 = true;
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
