{ config, lib, pkgs, pkgsSelf, ... }:

{
  home.homeDirectory = "/home/moritz";

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  xdg.configFile = let
    mimeapps = {
      "text/" = "nvim.desktop";
      "text/html" = "firefox.desktop";

      "image/" = "imv-dir.desktop";

      "video/" = "mpv.desktop";

      "audio/" = "mpv.desktop";

      "application/epub+zip" = "org.pwmt.zathura.desktop";
      "application/javascript" = "nvim.desktop";
      "application/json" = "nvim.desktop";
      "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
      "application/postscript" = "org.pwmt.zathura-ps.desktop";
      "application/python" = "nvim.desktop";
      "application/rss+xml" = "nvim.desktop";
      "application/x-javascript" = "nvim.desktop";
      "application/x-sh" = "nvim.desktop";
      "application/x-shellscript" = "nvim.desktop";
      "application/x-wine-extension-ini" = "nvim.desktop";
      "application/xml" = "firefox.desktop";

      "inode/directory" = "lf.desktop";

      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/mailto" = "thunderbird.desktop";
    };
  in {
    "mimeapps_patterns.list".text = "${lib.concatLines
      (map ({ name, value }: "${name}=${value}") (lib.attrsToList mimeapps))}";

    "mimeapps.list".source = pkgs.runCommand "mimeapps.list" { } ''
      declare -A mimeapps=(
        ${
          lib.concatLines (map ({ name, value }: ''["${name}"]="${value}"'')
            (lib.attrsToList mimeapps))
        }
      )

      cat <<_EOF >"$out"
      [Added Associations]

      [Removed Associations]

      [Default Applications]
      _EOF

      for mimeapp_prefix in "''${!mimeapps[@]}"; do
        if [[ "''${mimeapp_prefix: -1}" == '/' ]]; then
          while IFS="" read -r mimetype; do
            if [[ "$mimetype" == "$mimeapp_prefix"* ]]; then
              echo "$mimetype=''${mimeapps[$mimeapp_prefix]}"
            fi
          done < "${pkgs.shared-mime-info}/share/mime/types"
        else
          echo "$mimeapp_prefix=''${mimeapps[$mimeapp_prefix]}"
        fi
      done >> "$out"
    '';
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

  home.packages = [
    pkgsSelf.xdg-open

    # Make some applications find the default terminal when opening desktop files
    (pkgs.writeShellScriptBin "xdg-terminal-exec" ''
      foot "$@"
    '')
  ];
}
