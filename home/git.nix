{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Moritz Vogel";
        email = "moritzv7@gmail.com";
      };
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
  };

  programs.delta = {
    enable = true;
    options = {
      line-numbers = true;
      hunk-header-style = "";
    };
  };
}
