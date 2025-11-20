{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Moritz Vogel";
    userEmail = "moritzv7@gmail.com";

    extraConfig = {
      alias.l = "log --all --graph --pretty='format:%C(yellow)%h%Creset %C(magenta)%aN%C(auto)%d%Creset %s %Cblue(%ah)'";
      branch.sort = "-committerdate";
      column.ui = "auto";
      core.autocrlf = "input";
      diff = {
        algorithm = "histogram";
        mnemonicPrefix = true;
        renames = true;
      };
      fetch.all = true;
      init.defaultBranch = "main";
      pull.ff = "only";
      push.autoSetupRemote = true;
      tag.sort = "version:refname";
    };

    delta = {
      enable = true;
      options = {
        line-numbers = true;
        hunk-header-style = "";
      };
    };
  };
}
