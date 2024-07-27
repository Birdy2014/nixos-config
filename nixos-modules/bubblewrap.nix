{ config, lib, pkgs, ... }:

# TODO: create namespaces. --unshare-pid breaks steam.

let
  cfg = config.my.bubblewrap;

  mkBind = dir: [ "--bind" dir dir ];
  mkRoBind = dir: [ "--ro-bind" dir dir ];
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
    in (lib.concatMap mkRoBind binds)
    ++ [ "--proc" "/proc" "--dev" "/dev" "--tmpfs" "/tmp" "--clearenv" ];
    desktopCommon = let
      envs =
        [ "HOME" "PATH" "LANG" "TERM" "XDG_RUNTIME_DIR" "XDG_SESSION_TYPE" ];
    in [ "--tmpfs" "$XDG_RUNTIME_DIR" ] ++ (lib.concatMap mkEnvBind envs);
    wayland = (mkEnvBind "WAYLAND_DISPLAY")
      ++ (mkRoBind "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY");
    xorg = (mkEnvBind "DISPLAY") ++ (mkRoBind "/tmp/.X11-unix");
    sound = [
      "--ro-bind"
      "$XDG_RUNTIME_DIR/pulse/native"
      "$XDG_RUNTIME_DIR/pulse/native"
      "--ro-bind-try"
      "$HOME/.config/pulse/cookie"
      "$HOME/.config/pulse/cookie"
      "--ro-bind-try"
      "$XDG_RUNTIME_DIR/pipewire-0"
      "$XDG_RUNTIME_DIR/pipewire-0"
    ];
    gpu = (mkDevBind "/dev/dri") ++ (mkRoBind "/sys");
    dbus = (mkEnvBind "DBUS_SESSION_BUS_ADDRESS")
      ++ (mkRoBind "$XDG_RUNTIME_DIR/bus");
  };

  wrappedBins = pkgs.runCommand "bubblewrap-wrapped-binaries" {
    preferLocalBuild = true;
    allowSubstitutes = false;
    meta.priority = -1;
  } ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications

    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (command: value:
      let
        mkHomeBind = dir: [ "--bind" dir "$HOME" "--chdir" "$HOME" ];

        args = defaultArgs.common ++ (if value.home == null then [
          "--tmpfs"
          "$HOME"
          "--chdir"
          "$HOME"
        ] else
          mkHomeBind value.home) ++ (lib.optionals value.allowDesktop
            (defaultArgs.desktopCommon ++ defaultArgs.dbus
              ++ defaultArgs.wayland ++ defaultArgs.xorg ++ defaultArgs.sound
              ++ defaultArgs.gpu)) ++ (lib.optionals (value.extraBinds != null)
                (lib.concatMap mkBind value.extraBinds))
          ++ (lib.optionals (value.extraRoBinds != null)
            (lib.concatMap mkRoBind value.extraRoBinds))
          ++ (lib.optionals (value.extraDevBinds != null)
            (lib.concatMap mkDevBind value.extraDevBinds));
      in ''
        cat <<'_EOF' >$out/bin/${command}
          #! ${pkgs.runtimeShell} -e
          exec ${pkgs.bubblewrap}/bin/bwrap ${
            lib.concatStringsSep " " (map (arg: ''"${arg}"'') args)
          } ${builtins.toString value.executable} "$@"
        _EOF

        chmod 0755 $out/bin/${command}

        ${lib.optionalString (value.desktop != null) ''
          substitute ${value.desktop} $out/share/applications/$(basename ${value.desktop}) \
            --replace ${value.executable} $out/bin/${command}
        ''}
      '') cfg)}
  '';
in {
  options.my.bubblewrap = lib.mkOption {
    description = "sandboxed applications";
    default = { };
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
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

        home = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "home directory";
        };

        allowDesktop = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "allow access to desktop resources";
        };

        extraBinds = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          description = "Extra read-write binds";
        };

        extraRoBinds = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          description = "Extra read-only binds";
        };

        extraDevBinds = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          description = "Extra dev binds";
        };
      };
    });
  };

  config =
    lib.mkIf (cfg != { }) { environment.systemPackages = [ wrappedBins ]; };
}
