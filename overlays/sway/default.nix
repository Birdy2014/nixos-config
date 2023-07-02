final: prev: {
  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
    patches = (old.patches or [ ])
      ++ [ ./Don-t-move-container-to-cousin.patch ];
  });
}
