final: prev: {
  imv = prev.imv.overrideAttrs (old: {
    patches = (old.patches or [ ])
      ++ [ ./0001-Set-cursor-image-to-left_ptr.patch ];
  });
}
