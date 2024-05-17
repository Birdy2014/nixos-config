{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [ vim-tmux-navigator ];
    extraConfigBeforePlugins = builtins.readFile ./tmux.conf;
  };
}
