{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Moritz Vogel";
    userEmail = "moritzv7@gmail.com";

    extraConfig = {
      core = {
        autocrlf = "input";
      };
      pull = {
        ff = "only";
      };
    };

    difftastic = {
      enable = true;
      display = "inline";
    };
  };
}
