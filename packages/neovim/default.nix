{ lib, wrapNeovimUnstable, neovim-unwrapped, vimPlugins, fetchFromGitHub, ... }:

let
  config = import ./config.nix { inherit vimPlugins fetchFromGitHub; };
  configBefore = config.configBefore;
  plugins = config.plugins;
in wrapNeovimUnstable neovim-unwrapped {
  vimAlias = true;
  viAlias = true;

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
