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

  my.bubblewrap.wine = {
    applications = [
      {
        executable = "${pkgs.wineWowPackages.stable}/bin/wine";
        name = "wine-bwrap";
      }
      {
        executable = "${pkgs.winetricks}/bin/winetricks";
        name = "winetricks-bwrap";
      }
    ];
    allowDesktop = true;
    persistentHome = true;
    extraEnvBinds = [ "WINEPREFIX" ];
    extraRoBinds = [ "$HOME/Downloads" ];
    extraBinds = [ "/sys/class/input" ];
    extraDevBinds = [ "/dev/input" "/dev/uinput" ];
  };
}
