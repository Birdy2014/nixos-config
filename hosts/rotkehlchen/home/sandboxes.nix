{
  jail,
  pkgs,
  ...
}:

{
  home.packages = [
    (jail "spotify" pkgs.spotify (
      with jail.combinators;
      [
        gui
        gpu
        network
        (readwrite-xdg "spotify")
        notifications

        (dbus {
          own = [
            "org.mpris.MediaPlayer2.spotify"
          ];
          talk = [
            "org.freedesktop.ScreenSaver"
            "org.gnome.SettingsDaemon.MediaKeys"
            "org.kde.StatusNotifierWatcher"
          ];
        })
      ]
    ))

    (jail "vesktop" pkgs.vesktop (
      with jail.combinators;
      [
        desktop
        gpu
        network
        notifications
        (readwrite-xdg "vesktop")
      ]
    ))
  ];
}
