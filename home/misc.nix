{ config, osConfig, pkgs, pkgsSelf, ... }:

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
    keepassxc
    zathura
    neovide
    hotspot
    libreoffice
    thunderbird
    element-desktop

    (pkgs.writers.writePython3Bin "wine-sandbox" {
      flakeIgnore = [ "E501" "E111" ];
    } # python
      ''
        # TODO: also wrap winetricks
        # TODO: add option to allow network access

        import argparse
        import subprocess
        import os

        WINE_WRAPPER = "${config.my.bubblewrap.wine.finalPackage}/bin/wine"

        parser = argparse.ArgumentParser()
        parser.add_argument("-p", "--prefix", "--pfx", required=True, default=os.environ.get("WINEPREFIX"), dest="wineprefix")
        parser.add_argument("-d", "--dir", required=False, dest="workdir")
        parser.add_argument("command", nargs="+")

        args = parser.parse_args()

        program_executable = os.path.abspath(args.command.pop(0))
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

        child_env = os.environ
        child_env["WINEPREFIX"] = wineprefix
        child_env["WORKDIR"] = args.workdir or os.path.dirname(program_executable)

        if "WINEDLLOVERRIDES" not in child_env:
          child_env["WINEDLLOVERRIDES"] = ""

        # Disable creation of file associations
        child_env["WINEDLLOVERRIDES"] += ";winemenubuilder.exe=d"

        # Disable wine-mono prompt
        child_env["WINEDLLOVERRIDES"] += ";mscoree=d;mshtml=d"

        print(f"Bind-mounting {child_env["WINEPREFIX"]} and {child_env["WORKDIR"]} and executing {program_executable}")

        subprocess.run([WINE_WRAPPER, program_executable] + args.command, env=child_env)
      '')
  ];

  my.bubblewrap.wine = {
    applications = [ pkgs.wineWow64Packages.stable ];
    allowDesktop = true;
    allowX11 = true;
    extraEnvBinds = [ "WINEPREFIX" "WINEDLLOVERRIDES" ];
    extraBinds = [ "$WINEPREFIX" "$WORKDIR" ];
    extraDevBinds = [ "/dev/input" "/dev/uinput" ];
    installPackage = false;
  };
}
