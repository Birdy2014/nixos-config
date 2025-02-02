{ osConfig, pkgs, pkgsSelf, ... }:

{
  services.easyeffects.enable = true;

  services.gnome-keyring.enable = true;

  nix.gc = {
    automatic = osConfig.nix.gc.automatic;
    frequency = osConfig.nix.gc.dates;
    options = osConfig.nix.gc.options;
  };

  home.packages = with pkgs; [
    # CLI
    libqalculate
    yt-dlp
    bashmount
    pkgsSelf.playerctl-current
    syncplay-nogui
    gdb

    # GUI
    pavucontrol
    helvum
    obsidian
    keepassxc
    zathura
    mcomix
    neovide

    libreoffice
    thunderbird
    mumble
  ];

  # TODO: Wrapper script that handles WINEPREFIX and binds the directory of the executable file to bwrap
  /* my.bubblewrap.wine = {
       applications = with pkgs; [ wineWowPackages.stable winetricks ];
       allowDesktop = true;
       persistentHome = true;
       extraEnvBinds = [ "WINEPREFIX" ];
       extraRoBinds = [ "$HOME/Downloads" ];
       extraBinds = [ "/sys/class/input" ];
       extraDevBinds = [ "/dev/input" "/dev/uinput" ];
     };
  */
}
