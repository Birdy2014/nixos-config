{ pkgs, inputs, ... }:

let
  jail = inputs.jail-nix.lib.extend {
    inherit pkgs;
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

        theme =
          with builtinCombinators;
          compose (
            [
              (readonly-paths-from-var "XDG_DATA_DIRS" ":")
              (dbus {
                talk = [
                  "ca.desrt.dconf"
                  "org.a11y.Bus"
                  "org.freedesktop.DBus"
                  "org.freedesktop.portal.*"
                  "org.gtk.vfs"
                  "org.gtk.vfs.*"
                ];
              })
            ]
            ++ (
              [
                "NIXOS_OZONE_WL"
                "QT_QPA_PLATFORMTHEME"
                "PLASMA_INTEGRATION_USE_PORTAL"
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
              ]
              |> map (name: "\"${name}\"")
              |> map noescape
              |> map readonly
            )
          );
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
            [ -d ${unjailed}/share ] && cp --no-preserve=mode -r ${unjailed}/share $out
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
