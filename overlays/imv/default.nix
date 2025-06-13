final: prev: {
  imv =
    (prev.imv.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ prev.libwebp ];
      src = prev.fetchFromGitHub {
        owner = "Birdy2014";
        repo = "imv";
        rev = "c804001c49fa0dc69db9fde19eb603d0bc67ae20";
        hash = "sha256-HC4oiGlBEKoFh7e0nq9dDXBwtq8rcOM9Dmv0JHWmdzc=";
      };
      mesonFlags = old.mesonFlags ++ [ "-Dlibwebp=enabled" ];
      patches = [ ];
    })).override
      {
        withBackends = [
          "libjxl"
          "libtiff"
          "libjpeg"
          "libpng"
          "librsvg"
          "libheif"
          "libnsgif"
        ];
      };
}
