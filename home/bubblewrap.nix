{ config, lib, pkgs, ... }:

let
  cfg = config.my.bubblewrap;

  mkBind = dir: [ "--bind" dir dir ];
  mkRoBind = dir: [ "--ro-bind" dir dir ];
  mkRoBindTry = dir: [ "--ro-bind-try" dir dir ];
  mkDevBind = dir: [ "--dev-bind-try" dir dir ];
  mkEnvBind = env: [ "--setenv" env "\$${env}" ];

  defaultArgs = {
    common = let
      binds = [
        "/usr"
        "/bin"
        "/nix"
        "/run/current-system"
        "/run/opengl-driver"
        "/run/opengl-driver-32"
        "/etc"
        "/run/systemd/resolve"
      ];
    in (lib.concatMap mkRoBind binds) ++ [
      "--proc"
      "/proc"
      "--dev"
      "/dev"
      "--tmpfs"
      "/tmp"
      "--clearenv"
      "--unshare-user"
      "--unshare-uts"
      "--unshare-cgroup"
      "--setenv"
      "NIXOS_XDG_OPEN_USE_PORTAL"
      "1"
    ];

    desktopCommon = let
      envs =
        [ "HOME" "PATH" "LANG" "TERM" "XDG_RUNTIME_DIR" "XDG_SESSION_TYPE" ];
    in [ "--tmpfs" "$XDG_RUNTIME_DIR" ] ++ (lib.concatMap mkEnvBind envs);

    wayland = (mkEnvBind "WAYLAND_DISPLAY")
      ++ (mkRoBind "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY");

    xorg = (mkEnvBind "DISPLAY") ++ (mkRoBind "/tmp/.X11-unix");

    sound = (mkRoBind "$XDG_RUNTIME_DIR/pulse/native")
      ++ (lib.concatMap mkRoBindTry [
        "$HOME/.config/pulse/cookie"
        "$XDG_RUNTIME_DIR/pipewire-0"
      ]);

    gpu = (mkDevBind "/dev/dri") ++ (mkRoBind "/sys");

    dbus = (mkEnvBind "DBUS_SESSION_BUS_ADDRESS")
      ++ (mkRoBind "$XDG_RUNTIME_DIR/bus");

    newSession = [ "--new-session" ];

    unshareIpc = [ "--unshare-ipc" "--unshare-pid" ];

    theming = (lib.concatMap mkEnvBind [
      "QT_QPA_PLATFORMTHEME"
      "PLASMA_INTEGRATION_USE_PORTAL"
    ]) ++ (lib.concatMap mkRoBind [
      "$XDG_CONFIG_HOME/kdeglobals"
      "$XDG_CONFIG_HOME/kcminputrc"
      "$XDG_CONFIG_HOME/gtk-3.0/settings.ini"
      "$XDG_CONFIG_HOME/gtk-3.0/gtk.css"
      "$XDG_CONFIG_HOME/gtk-4.0/settings.ini"
      "$XDG_CONFIG_HOME/gtk-4.0/gtk.css"
      "$XDG_DATA_HOME/icons"
    ]);
  };

  wrappedBins = pkgs.runCommand "bubblewrap-wrapped-binaries" {
    preferLocalBuild = true;
    allowSubstitutes = false;
    meta.priority = -1;
  } ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications

    ${lib.concatStringsSep "\n" (lib.flatten (lib.mapAttrsToList
      (sandboxName: sandboxConfig:
        let
          mkHomeBind = dir: [ "--bind" dir "$HOME" "--chdir" "$HOME" ];
          mkTmpHomeBind = [ "--tmpfs" "$HOME" "--chdir" "$HOME" ];

          commonArgs = defaultArgs.common
            ++ (if !sandboxConfig.persistentHome then
              mkTmpHomeBind
            else
              mkHomeBind sandboxConfig.persistentHomeDir);

          desktopArgs = (lib.optionals sandboxConfig.allowDesktop
            (defaultArgs.desktopCommon ++ defaultArgs.dbus
              ++ defaultArgs.wayland ++ defaultArgs.xorg ++ defaultArgs.sound
              ++ defaultArgs.gpu ++ defaultArgs.theming));

          args = commonArgs ++ desktopArgs
            ++ (lib.optionals sandboxConfig.newSession defaultArgs.newSession)
            ++ (lib.optionals sandboxConfig.unshareIpc defaultArgs.unshareIpc)
            ++ (lib.concatMap mkBind sandboxConfig.extraBinds)
            ++ (lib.concatMap mkRoBind sandboxConfig.extraRoBinds)
            ++ (lib.concatMap mkDevBind sandboxConfig.extraDevBinds)
            ++ (lib.concatMap mkEnvBind sandboxConfig.extraEnvBinds);
        in map ({ name, executable, desktop }: ''
          executable_out_path="$out/bin/${
            if isNull name then ''$(basename "${executable}")'' else name
          }"

          cat <<'_EOF' >"$executable_out_path"
            #! ${pkgs.runtimeShell} -e
            ${
              lib.optionalString sandboxConfig.persistentHome
              ''mkdir -p "${sandboxConfig.persistentHomeDir}"''
            }
            export PATH="${
              lib.concatStringsSep ":"
              (lib.map ({ executable, ... }: ''$(dirname "${executable}")'')
                sandboxConfig.applications)
            }:$PATH"
            exec ${pkgs.bubblewrap}/bin/bwrap ${
              lib.concatStringsSep " " (map (arg: ''"${arg}"'') args)
            } ${builtins.toString executable} "$@"
          _EOF

          chmod 0755 "$executable_out_path"

          ${lib.optionalString (desktop != null) ''
            substitute ${desktop} $out/share/applications/$(basename ${desktop}) \
              --replace ${executable} "$executable_out_path"
          ''}
        '') sandboxConfig.applications) cfg))}
  '';
in {
  options.my.bubblewrap = lib.mkOption {
    description = "sandboxed applications";
    default = { };
    type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
      options = {
        applications = lib.mkOption {
          type = lib.types.listOf (lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Name of executable wrapper";
              };

              executable = lib.mkOption {
                type = lib.types.path;
                description = "Executable to run sandboxed";
              };

              desktop = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = null;
                description =
                  ".desktop file to modify. Only necessary if it uses the absolute path to the executable.";
              };
            };
          });
          description = "Applications to run sandboxed";
        };

        persistentHome = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "use persistentHomeDir as home directory";
        };

        persistentHomeDir = lib.mkOption {
          type = lib.types.str;
          default = "$HOME/.sandboxed/${name}";
          description = "default: `~/.sandboxed/<name>`";
        };

        newSession = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "add `--new-session` to workaround CVE-2017-5226";
        };

        unshareIpc = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "create new ipc and pid namespaces";
        };

        allowDesktop = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "allow access to desktop resources";
        };

        extraBinds = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Extra read-write binds";
        };

        extraRoBinds = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Extra read-only binds";
        };

        extraDevBinds = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Extra dev binds";
        };

        extraEnvBinds = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Extra environment variables to passthrough";
        };
      };
    }));
  };

  config = lib.mkIf (cfg != { }) { home.packages = [ wrappedBins ]; };
}
