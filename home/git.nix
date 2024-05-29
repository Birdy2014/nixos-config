{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Moritz Vogel";
    userEmail = "moritzv7@gmail.com";

    extraConfig = {
      core.autocrlf = "input";
      pull.ff = "only";
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
