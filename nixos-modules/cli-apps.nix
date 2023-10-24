{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (wrapNeovim neovim-unwrapped {
      # gcc is required for nvim-treesitter and nodejs is required for markdown-preview.nvim
      extraMakeWrapperArgs =
        "--prefix PATH : ${lib.makeBinPath [ gcc13 nodejs_18 ]}";
      vimAlias = true;
      viAlias = true;
    })
    ripgrep
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
    compsize
    trash-cli
    ffmpeg
    cifs-utils
    keyutils
    sshfs

    inputs.self.packages.${pkgs.system}.xdg-open
    inputs.self.packages.${pkgs.system}.playerctl-current
  ];

  services.udisks2.enable = true;

  documentation.man.enable = true;

  # Needed for zsh completions
  environment.pathsToLink = [ "/share/zsh" ];
}
