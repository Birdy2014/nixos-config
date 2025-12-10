{
  config,
  lib,
  pkgs,
  pkgsSelf,
  ...
}:

{
  options.my.programs.neovim.full = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Include all treesitter grammars and language servers";
  };

  config = {
    environment.systemPackages = with pkgs; [
      (pkgsSelf.neovim.override {
        colorscheme = config.my.desktop.colorscheme;
        withLanguageServers = config.my.programs.neovim.full;
        withAllTreesitterGrammars = config.my.programs.neovim.full;
        waylandSupport = config.my.desktop.enable;
      })
      ripgrep
      git
      file
      psmisc
      compsize
      ldns # for drill
      nix-tree
      htop
      fd

      man-pages
    ];

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    programs.command-not-found.enable = false;

    documentation = {
      info.enable = false;
      dev.enable = true;
    };

    security.pam.services.systemd-run0.enable = true;

    security.sudo.extraConfig = ''
      Defaults env_keep += "EDITOR"
    '';

    # Needed for zsh completions
    environment.pathsToLink = [ "/share/zsh" ];
  };
}
