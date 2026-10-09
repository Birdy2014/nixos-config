{
  pkgs,
  pkgsSelf,
  inputs,
  ...
}:

let
  jail = inputs.jail-nix.lib.extend {
    inherit pkgs;

    basePermissions =
      combinators: with combinators; [
        base
        (readonly "/nix/store")
        fake-passwd
      ];

    additionalCombinators =
      builtinCombinators: with builtinCombinators; {
        readwrite-xdg =
          name:
          with builtinCombinators;
          [
            "~/.config/${name}"
            "~/.cache/${name}"
            "~/.local/share/${name}"
            "~/.local/state/${name}"
          ]
          |> map noescape
          |> map try-readwrite
          |> compose;

        desktop =
          with builtinCombinators;
          compose (
            [
              gui
              (dbus {
                talk = [
                  "ca.desrt.dconf"
                  "org.a11y.Bus"
                  "org.freedesktop.DBus"
                  "org.freedesktop.portal.*"
                  "org.freedesktop.ScreenSaver"
                  "org.gtk.vfs"
                  "org.gtk.vfs.*"
                ];
              })
              (add-pkg-deps [ pkgsSelf.xdg-open ])
              (set-env "NIXOS_XDG_OPEN_USE_PORTAL" "1")
            ]
            ++ (
              [
                # XDG
                "XDG_DATA_DIRS"
                "XDG_CURRENT_DESKTOP"
                "XDG_CONFIG_HOME"
                "XDG_DATA_HOME"
                "XDG_SESSION_TYPE"

                # GTK
                "GTK_THEME"

                # QT
                "QT_QPA_PLATFORMTHEME"
                "PLASMA_INTEGRATION_USE_PORTAL"
                "QT_PLUGIN_PATH"
              ]
              |> map fwd-env
            )
            ++ (
              [
                "$XDG_CONFIG_HOME/kdeglobals"
                "$XDG_CONFIG_HOME/kcminputrc"
                "$XDG_CONFIG_HOME/gtk-3.0/settings.ini"
                "$XDG_CONFIG_HOME/gtk-3.0/gtk.css"
                "$XDG_CONFIG_HOME/gtk-4.0/settings.ini"
                "$XDG_CONFIG_HOME/gtk-4.0/gtk.css"
                "$XDG_DATA_HOME/icons"
                "/etc/profiles/per-user/moritz"
              ]
              |> map (name: "\"${name}\"")
              |> map noescape
              |> map readonly
            )
          );

        gamepads =
          with jail.combinators;
          include-once "gamepads" (add-runtime /* bash */ ''
            joystick_suffix='-event-joystick'
            for joystick_path in /dev/input/by-path/*"$joystick_suffix"; do
              [ -e "$joystick_path" ] || continue
              prefix=''${joystick_path%"$joystick_suffix"}
              for path in "$prefix"*{"$joystick_suffix",-hidraw}; do
                dev_path="$(readlink -f "$path")"
                RUNTIME_ARGS+=(--dev-bind "$dev_path" "$dev_path")
              done
            done
          '');
      };
  };

  addDesktopFiles =
    name: unjailed: jailed:
    pkgs.symlinkJoin {
      inherit name;
      paths = [
        jailed
        (pkgs.runCommand "${name}-resources"
          {
            nativeBuildInputs = [
              pkgs.coreutils
              pkgs.gnused
            ];
          }
          ''
            mkdir -p $out
            [ -d ${unjailed}/share ] && cp --no-preserve=mode -rL ${unjailed}/share $out
            if [ -d "${unjailed}/share/applications" ] && [ "$(ls $out/share/applications | wc -l)" -gt 0 ]; then
              sed -Ei 's|(^[[:space:]]*Exec[[:space:]]*=[[:space:]]*)([^ ]*/)?([^ /]*)|\1'${jailed}'/bin/\3|g' $out/share/applications/*
            fi
          ''
        )
      ];
    };
in
{
  _module.args.jail = {
    __functor =
      _: name: unjailed: combinators:
      addDesktopFiles name unjailed (jail name unjailed combinators);
    combinators = jail.combinators;
  };
}
