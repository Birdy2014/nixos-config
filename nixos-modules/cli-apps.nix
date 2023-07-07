{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    gcc13 # Needed for neovim treesitter
    ripgrep
    lf
    git
    python3
    file
    btop
    nvtop-amd
    tmux
    psmisc
    libqalculate
    unrar
    unzip
    p7zip
    zip
    atool
    yt-dlp
    socat
    nil # nix language server
    neofetch
    pciutils
    usbutils
    alsaUtils

    cifs-utils
    keyutils
  ];
}
