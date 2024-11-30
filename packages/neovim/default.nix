{ lib, wrapNeovimUnstable, neovim-unwrapped, vimPlugins, fetchFromGitHub
, vimUtils, git, ripgrep, libqalculate, colorscheme ? "gruvbox-material-dark"
, withLanguageServers ? false, nil, bash-language-server, clang-tools
, typescript-language-server, pyright }:

let
  config = import ./config.nix {
    inherit vimPlugins fetchFromGitHub colorscheme;
    buildVimPlugin = vimUtils.buildVimPlugin;
  };
  configBefore = config.configBefore;
in wrapNeovimUnstable neovim-unwrapped {
  vimAlias = true;
  viAlias = true;

  wrapperArgs = "--prefix PATH : ${
      lib.makeBinPath ([ git ripgrep libqalculate ]
        ++ lib.optionals withLanguageServers [
          nil
          bash-language-server
          clang-tools
          typescript-language-server
          pyright
        ])
    }";

  plugins = map (plugin: { inherit plugin; })
    (lib.flatten (map ({ plugin, ... }: plugin) config.plugins));

  luaRcContent = lib.concatStringsSep "\n" ((map builtins.readFile configBefore)
    ++ (map ({ config, ... }:
      ''
        do
      '' + (if builtins.typeOf config == "path" then
        builtins.readFile config
      else
        config) + ''

          end'') (lib.filter (x: lib.hasAttr "config" x) config.plugins)));
}
