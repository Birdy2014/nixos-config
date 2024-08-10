{ ... }:

{
  programs.bash.interactiveShellInit = ''
    export HISTCONTROL=ignoreboth:erasedups
    export HISTFILE="$HOME/.local/share/bash_history"
  '';
}
