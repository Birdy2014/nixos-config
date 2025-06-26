{
  osConfig,
  pkgs,
  pkgsSelf,
  ...
}:

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
    cifs-utils
    unrar
    unzip
    _7zz
    zip
    alsa-utils
    trash-cli
    progress
    ffmpeg
    libqalculate
    yt-dlp
    bashmount
    pkgsSelf.playerctl-current
    gdb
    pkgsSelf.wine-sandbox

    # GUI
    pavucontrol
    helvum
    obsidian
    zathura
    neovide
    hotspot
    libreoffice
    thunderbird
    element-desktop
    foliate
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
      settings = {
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "de-nodeadkeys";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-de-nodeadkeys";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "mozc";
            Layout = "";
          };
          "GroupOrder"."0" = "Default";
        };
        # The F13 key is called "Tools" for some reason
        globalOptions."Hotkey/TriggerKeys"."0" = "Tools";
      };
    };
  };
}
