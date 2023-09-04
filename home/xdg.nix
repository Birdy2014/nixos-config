{ config, ... }:

{
  home.homeDirectory = "/home/moritz";

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  home.sessionVariables = let
    home = config.home.homeDirectory;
    cacheHome = config.xdg.cacheHome;
    configHome = config.xdg.configHome;
    dataHome = config.xdg.dataHome;
  in {
    EDITOR = "nvim";
    VISUAL = "nvim";

    ANDROID_HOME = "${home}/Android/Sdk";
    CARGO_HOME = "${dataHome}/cargo";
    CUDA_CACHE_PATH = "${cacheHome}/nv";
    GOPATH = "${dataHome}/go";
    GRADLE_USER_HOME = "${dataHome}/gradle";
    JUPYTER_CONFIG_DIR = "${configHome}/jupyter";
    KDEHOME = "${configHome}/kde";
    MPLAYER_HOME = "${configHome}/mplayer";
    MYSQL_HISTFILE = "${dataHome}/mysql_history";
    NODE_REPL_HISTORY = "${dataHome}/node_repl_history";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";
    RUSTUP_HOME = "${dataHome}/rustup";
    SQLITE_HISTORY = "${dataHome}/sqlite_history";
  };
}
