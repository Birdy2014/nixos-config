{ osConfig, lib, pkgs, ... }:

{
  config = lib.mkIf osConfig.my.gaming.enable {
    my.bubblewrap = {
      steam = {
        applications = [ pkgs.steam ];
        persistentHome = true;
        allowDesktop = true;
        allowX11 = true;
        unshareIpc = false;
        unshareNet = false;
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
        unshareNet = false;
        extraBinds = [ "$HOME/.local/share/PrismLauncher" ];
        extraRoBinds = [ "$HOME/Downloads" ];
      };

      heroic = {
        applications = [ pkgs.heroic ];
        allowDesktop = true;
        allowX11 = true;
        unshareNet = false;
        persistentHome = true;
        extraBinds = [ "/run/media/moritz/games/Heroic" "/sys/class/input" ];
        extraDevBinds = [ "/dev/input" "/dev/uinput" ];
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
