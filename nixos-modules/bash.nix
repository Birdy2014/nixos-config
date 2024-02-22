{ ... }:

{
  programs.bash.shellInit = ''
    export HISTCONTROL=ignoreboth:erasedups
  '';
}
