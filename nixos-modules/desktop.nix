{ pkgs, ... }:

{
  hardware.opengl.enable = true;

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

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.moritz.enableGnomeKeyring = true;
  security.pam.services.swaylock = { };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      enable = true;

      defaultFonts.serif = [ "NotoSerif Nerd Font" "Noto Serif CJK JP" ];
      defaultFonts.sansSerif = [ "NotoSans Nerd Font" "Noto Sans CJK JP" ];
      defaultFonts.monospace =
        [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK JP" ];
      defaultFonts.emoji = [ "Noto Color Emoji" ];
    };

    packages = with pkgs; [
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
    package = pkgs.firefox-bin;
    languagePacks = [ "en-US" "de" ];

    # policies in /etc/firefox/policies/policies.json override the policies defined by the firefox-bin derivation
    policies = { DisableAppUpdate = true; };
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
    pavucontrol
    pw-viz
    obsidian
    keepassxc
    (mpv.override { scripts = [ mpvScripts.mpris ]; })
    imv
    zathura
    mcomix
    dolphin
    kio-fuse
    libsForQt5.kio
    libsForQt5.kio-extras
    libreoffice

    discord
    thunderbird-bin
    mumble

    # dependencies of other dotfiles. TODO: Call directly
    playerctl

    syncplay
  ];
}
