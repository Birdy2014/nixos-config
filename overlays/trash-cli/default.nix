final: prev: {
  trash-cli = prev.trash-cli.overrideAttrs (old: {
    patches = (old.patches or [ ])
      ++ [ ./0001-add-cifs-to-accepted-fstypes.patch ];
  });
}
