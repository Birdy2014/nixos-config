{ ... }:

{
  home.homeDirectory = "/home/moritz";

  xdg = { enable = true; };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    ANDROID_HOME = "$HOME/Android/Sdk";
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    GOPATH = "$XDG_DATA_HOME/go";
    GRADLE_USER_HOME = "$XDG_DATA_HOME/gradle";
    JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    KDEHOME = "$XDG_CONFIG_HOME/kde";
    MPLAYER_HOME = "$XDG_CONFIG_HOME/mplayer";
    MYSQL_HISTFILE = "$XDG_DATA_HOME/mysql_history";
    NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite_history";
  };
}
