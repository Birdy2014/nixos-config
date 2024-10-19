{ lib, wrapNeovimUnstable, neovim-unwrapped, vimPlugins, fetchFromGitHub
, vimUtils, git, ripgrep, libqalculate, nil, nodePackages
, colorscheme ? "gruvbox-material-dark", withLanguageServers ? false
, clang-tools, rust-analyzer }:

let
  config = import ./config.nix {
    inherit vimPlugins fetchFromGitHub colorscheme;
    buildVimPlugin = vimUtils.buildVimPlugin;
  };
  configBefore = config.configBefore;
  plugins = config.plugins;
in wrapNeovimUnstable neovim-unwrapped {
  vimAlias = true;
  viAlias = true;

  wrapperArgs = "--prefix PATH : ${
      lib.makeBinPath
      ([ git ripgrep libqalculate nil nodePackages.bash-language-server ]
        ++ lib.optionals withLanguageServers [
          clang-tools
          nodePackages.typescript-language-server
          nodePackages.pyright
          rust-analyzer
        ])
    }";

  packpathDirs.myNeovimPackages = {
    start = lib.flatten (map ({ plugin, ... }: plugin)
      (lib.filter (x: lib.hasAttr "plugin" x) plugins));
    opt = [ ];
  };

  luaRcContent = lib.concatStringsSep "\n" ((map builtins.readFile configBefore)
    ++ (map ({ config, ... }:
      ''
        do
      '' + (if builtins.typeOf config == "path" then
        builtins.readFile config
      else
        config) + ''

          end'') (lib.filter (x: lib.hasAttr "config" x) plugins)));
}
