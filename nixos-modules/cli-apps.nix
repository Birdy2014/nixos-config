{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    gcc13 # Needed for neovim treesitter
    ripgrep
    lf
    git
    file
    nvtop-amd
    tmux
    psmisc
    libqalculate
    unrar
    unzip
    p7zip
    zip
    yt-dlp
    socat
    nil # nix language server
    neofetch
    pciutils
    usbutils
    alsaUtils

    # lf dependencies
    w3m
    trash-cli

    cifs-utils
    keyutils

    inputs.self.packages.x86_64-linux.xdg-open
  ];

  documentation.man = {
    enable = true;
    generateCaches = true;
  };

  # Needed for zsh completions
  environment.pathsToLink = [ "/share/zsh" ];
}
