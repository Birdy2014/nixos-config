{ config, pkgs, pkgsSelf, ... }:

{
  environment.systemPackages = with pkgs; [
    (pkgsSelf.neovim.override {
      colorscheme = config.my.desktop.colorscheme;
      withLanguageServers = config.my.desktop.enable;
    })
    ripgrep
    git
    file
    psmisc
    unrar
    unzip
    _7zz
    zip
    socat
    pciutils
    usbutils
    alsa-utils
    compsize
    trash-cli
    ffmpeg
    cifs-utils
    keyutils
    sshfs
    ldns # for drill
    binutils # for strings
    progress
    waypipe
    nix-tree
    htop

    man-pages
  ];

  services.udisks2.enable = true;

  documentation = {
    info.enable = false;
    dev.enable = true;
  };

  # Needed for zsh completions
  environment.pathsToLink = [ "/share/zsh" ];
}
