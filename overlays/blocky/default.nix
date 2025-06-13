final: prev: {
  blocky = prev.blocky.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./0001-Match-customdns-mappings-precisely-without-wildcards.patch
    ];
  });
}
