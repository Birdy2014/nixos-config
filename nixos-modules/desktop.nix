{ pkgs, ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.dconf.enable = true;

  security.polkit.enable = true;

  # Ugly way to make the call to "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1" in sway config work.
  system.activationScripts.symlinkPolkitGnomeAuthenticationAgent = ''
    mkdir -p  "/usr/lib/polkit-gnome"
    ln -f -s "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
  '';

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.moritz.enableGnomeKeyring = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      swaybg
      waybar
      wlsunset
      rofi-wayland
      dunst
      glib # for gsettings in sway config
      libnotify # for notify-send
      wl-clipboard
    ];
  };

  fonts = {
    enableDefaultFonts = true;

    fontconfig = {
      enable = true;

      defaultFonts.serif = [ "NotoSerif Nerd Font" "Noto Serif CJK JP" ];
      defaultFonts.sansSerif = [ "NotoSans Nerd Font" "Noto Sans CJK JP" ];
      defaultFonts.monospace =
        [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK JP" ];
      defaultFonts.emoji = [ "Noto Color Emoji" ];
    };

    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "Noto" ]; })
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      corefonts
    ];
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
  };

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.tridactyl = true;
    languagePacks = [ "en-US" "de" ];
  };

  services.syncthing = {
    enable = true;
    user = "moritz";
    group = "users";
    overrideFolders = false;
    overrideDevices = false;
    dataDir = "/home/moritz";
  };

  environment.systemPackages = with pkgs; [
    polkit_gnome

    pavucontrol
    easyeffects
    pw-viz
    obsidian
    keepassxc
    (mpv.override { scripts = [ mpvScripts.mpris ]; })
    imv
    zathura
    flameshot
    dolphin
    kio-admin
    kio-fuse
    libsForQt5.kio
    libsForQt5.kio-admin
    libsForQt5.kio-extras
    libreoffice

    discord
    thunderbird
    mumble

    # dependencies of dotfiles
    highlight
    poppler_utils
    ffmpeg
    ffmpegthumbnailer
    f3d
    jq
    playerctl
    gnome-epub-thumbnailer
  ];
}
