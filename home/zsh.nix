{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";

    defaultKeymap = "viins";

    shellAliases = {
      ls = "ls --color=auto";
      l = "ls -lAh";
      tm = "tmux new-session -A -s main";
      rm = "rm -I";
      cp = "cp -i";
    };

    sessionVariables = {
      MANPAGER = "nvim +Man!";
      LESS = "--mouse -r";
    };

    history = {
      extended = true;
      ignoreDups = true;
      ignorePatterns = [ "rm *" ];
      ignoreSpace = true;
      save = 100000;
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };

    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
      compinit
      zstyle ':completion:*' menu yes select
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

      zstyle ':completion:*' list-colors '''

      zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
      zstyle ':completion:*' group-name '''

      # vi navigation in completion menu
      zmodload zsh/complist
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -M menuselect 'l' vi-forward-char

      # Cancel completion with escape
      bindkey -M menuselect '^[' undo
    '';

    initExtra = ''
      autoload -Uz tetriscurses

      function set_terminal_title() {
        echo -en "\e]2;$@\a"
      }

      # Edit line in vim using space
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd ' ' edit-command-line

      # Delete chars with backspace
      bindkey -v '^?' backward-delete-char

      # Change cursor shape for different vi modes.
      _set-cursor-shape-for-keymap() {
          local shape=0
          case "$1" in
              main)       shape=5;;
              viins)      shape=5;; # vi insert: beam
              isearch)    shape=5;; # inc search: beam
              command)    shape=5;; # read a command name: beam
              vicmd)      shape=2;; # vi cmd: block
              visual)     shape=2;; # vi visual mode: block
              viopp)      shape=0;; # vi operator pending mode: block
          esac
          printf $'\e[%d q' "$shape"
      }

      zle-keymap-select() {
          _set-cursor-shape-for-keymap "$KEYMAP"
      }
      zle -N zle-keymap-select

      _set-cursor-shape-for-keymap main
      precmd() {
          _set-cursor-shape-for-keymap main
          set_terminal_title zsh - $(pwd)

          if [[ -z "$new_line_before_prompt" ]]; then
              new_line_before_prompt=1
          else
              echo
          fi
      }

      alias clear='unset new_line_before_prompt; clear'

      preexec() {
          _set-cursor-shape-for-keymap main
          set_terminal_title "$2"
      }
    '';

    envExtra = ''
      [ -d "$HOME/.local/bin" ] && [[ $PATH == *"$HOME/.local/bin"* ]] || export PATH=$HOME/.local/bin:$PATH
    '';

    loginExtra = ''
      if [ "$TTY" = "/dev/tty1" ]; then
        systemd-cat sway
        systemctl --user stop graphical-session.target
        exit
      fi
    '';

    localVariables = {
      KEYTIMEOUT = 1;

      # Local History
      HISTORY_BASE = "${config.xdg.dataHome}/zsh/history";

      # Theme
      SPACESHIP_USER_SHOW = "always";
      SPACESHIP_EXIT_CODE_SHOW = true;
      SPACESHIP_SUDO_SHOW = true;
      SPACESHIP_PROMPT_ADD_NEWLINE = false;
      SPACESHIP_EXIT_CODE_SYMBOL = "";

      SPACESHIP_PROMPT_ORDER = [
        "user" # Username section
        "dir" # Current directory section
        "host" # Hostname section
        "nix_shell"
        "git" # Git section (git_branch + git_status)
        "venv" # virtualenv section
        "conda" # conda virtualenv section
        "gnu_screen" # GNU Screen section
        "exec_time" # Execution time
        "line_sep" # Line break
        "jobs" # Background jobs indicator
        "exit_code" # Exit code section
        #"sudo"           # Sudo indicator
        "char" # Prompt character
      ];

      # Autosuggestion
      ZSH_AUTOSUGGEST_STRATEGY = [ "history" "completion" ];
    };

    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "per-directory-history";
        file = "per-directory-history.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "jimhester";
          repo = "per-directory-history";
          rev = "0687bbfd736da566472a6d67c2b45c501b73d405";
          sha256 = "sha256-7Z0qaDhgopKt9BDKSqdziw9jsVgiLLafs30wPPbz+oo=";
        };
      }
      {
        name = "spaceship-prompt";
        file = "spaceship.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "spaceship-prompt";
          repo = "spaceship-prompt";
          rev = "8461d88f59536087bbccd383d1c5da82e9fb90b3";
          sha256 = "sha256-gt9CuEHkjlsrc3svLh44L1SZA4OtIhcrFET9d2gJiLM=";
        };
      }
    ];
  };
}
