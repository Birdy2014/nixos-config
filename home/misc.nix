{
  config,
  osConfig,
  pkgs,
  pkgsSelf,
  ...
}:

{
  services.easyeffects.enable = true;

  services.gnome-keyring.enable = true;

  nix.gc = {
    automatic = osConfig.nix.gc.automatic;
    frequency = osConfig.nix.gc.dates;
    options = osConfig.nix.gc.options;
  };

  home.packages = with pkgs; [
    # CLI
    cifs-utils
    unrar
    unzip
    _7zz
    zip
    alsa-utils
    trash-cli
    progress
    ffmpeg
    libqalculate
    yt-dlp
    bashmount
    pkgsSelf.playerctl-current
    gdb

    # GUI
    pavucontrol
    helvum
    obsidian
    zathura
    neovide
    hotspot
    libreoffice
    thunderbird
    element-desktop

    (pkgs.writers.writePython3Bin "wine-sandbox"
      {
        flakeIgnore = [
          "E501"
          "E111"
          "E114"
        ];
      }
      # python
      ''
        import argparse
        import subprocess
        import os
        import sys
        import signal

        WINE_NO_NET_WRAPPER_BIN = "${config.my.bubblewrap.wine-no-net.finalPackage}/bin"
        WINE_NET_WRAPPER_BIN = "${config.my.bubblewrap.wine-net.finalPackage}/bin"

        parser = argparse.ArgumentParser()
        parser.add_argument("-p", "--prefix", "--pfx", required=True, default=os.environ.get("WINEPREFIX"), dest="wineprefix")
        parser.add_argument("-d", "--dir", dest="workdir")
        parser.add_argument("-n", "--allow-network", action="store_true", dest="allow_network")
        parser.add_argument("command", nargs="+")

        args = parser.parse_args()

        program_executable = args.command.pop(0)
        workdir = os.path.abspath(args.workdir) if args.workdir is not None else None
        wine_wrapper_bin = WINE_NET_WRAPPER_BIN if args.allow_network else WINE_NO_NET_WRAPPER_BIN
        wine_wrapper = os.path.join(wine_wrapper_bin, "wine")

        if program_executable == "winecfg":
          # winecfg can be executed with "wine winecfg"
          pass
        elif program_executable == "winetricks":
          wine_wrapper = os.path.join(wine_wrapper_bin, "winetricks")
          if len(args.command) == 0:
            print("Invalid winetricks command", file=sys.stderr)
            exit(1)
          program_executable = args.command.pop(0)
        else:
          program_executable = os.path.abspath(program_executable)
          if not os.path.isfile(program_executable):
            print(f"Executable '{program_executable}' doesn't exist.", file=sys.stderr)
            exit(1)
          if workdir is None:
            workdir = os.path.dirname(program_executable)

        # -- Setup wineprefix
        wineprefix = os.path.abspath(args.wineprefix)

        os.makedirs(args.wineprefix, exist_ok=True)

        user_dirs = ["Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos"]
        user_base_path = os.path.join(wineprefix, "drive_c", "users", os.environ["USER"])
        for dir in user_dirs:
          try:
            os.makedirs(os.path.join(user_base_path, dir))
            os.mknod(os.path.join(user_base_path, dir, ".keep"))
          except FileExistsError:
            # Directory or file already exists, nothing to do here
            pass

        # -- Setup child env
        child_env = os.environ
        child_env["WINEPREFIX"] = wineprefix

        # settings "wineprefix" here is a workaround in case there is not working directory
        child_env["WORKDIR"] = workdir or wineprefix

        if "WINEDLLOVERRIDES" not in child_env:
          child_env["WINEDLLOVERRIDES"] = ""

        # Disable creation of file associations
        child_env["WINEDLLOVERRIDES"] += ";winemenubuilder.exe=d"

        # Disable wine-mono prompt
        child_env["WINEDLLOVERRIDES"] += ";mscoree=d;mshtml=d"

        print(f"Bind-mounting {child_env["WINEPREFIX"]} and {child_env["WORKDIR"]} and executing {program_executable}")

        with subprocess.Popen([wine_wrapper, program_executable] + args.command, env=child_env, process_group=0) as process:
          signal.signal(signal.SIGINT, lambda signum, frame: os.killpg(os.getpgid(process.pid), signal.SIGINT))
      ''
    )
  ];

  my.bubblewrap =
    let
      common = {
        applications = [
          (pkgs.writeShellScriptBin "wine" ''
            ${pkgs.wineWowPackages.stable}/bin/wineserver -p1
            ${pkgs.wineWowPackages.stable}/bin/wine "$@"

            trap 'echo "waiting for wineserver to exit"' INT

            # wait for wineserver and all wine processes to finish
            ${pkgs.wineWowPackages.stable}/bin/wineserver -w
          '')
          pkgs.winetricks
        ];
        allowDesktop = true;
        allowX11 = true;
        extraEnvBinds = [
          "WINEPREFIX"
          "WINEDLLOVERRIDES"
        ];
        extraBinds = [
          "$WINEPREFIX"
          "$WORKDIR"
        ];
        extraDevBinds = [
          "/dev/input"
          "/dev/uinput"
        ];
        newSession = false; # Needed to be able to kill pgid
        installPackage = false;
      };
    in
    {
      wine-no-net = common;
      wine-net = common // {
        unshareNet = false;
      };
    };
}
