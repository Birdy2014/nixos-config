{
  stdenv,
  lib,
  fetchFromGitHub,
  asciidoc,
  cmocka,
  docbook_xsl,
  libxslt,
  meson,
  ninja,
  pkg-config,
  icu75,
  pango,
  inih,
  withWindowSystem ? if stdenv.hostPlatform.isLinux then "all" else "x11",
  xorg,
  libxkbcommon,
  libGLU,
  wayland,
  withBackends ? [
    "libheif"
    "libjpeg"
    "libjxl"
    "libnsgif"
    "libpng"
    "librsvg"
    "libtiff"
    "libwebp"
  ],
  libheif,
  libjpeg_turbo,
  libjxl,
  libnsgif,
  libpng,
  librsvg,
  libtiff,
  libwebp,
}:

let
  windowSystems = {
    all = windowSystems.x11 ++ windowSystems.wayland;
    x11 = [
      libGLU
      xorg.libxcb
      xorg.libX11
    ];
    wayland = [ wayland ];
  };

  backends = {
    inherit
      libheif
      libjxl
      libnsgif
      libpng
      librsvg
      libtiff
      libwebp
      ;
    libjpeg = libjpeg_turbo;
  };

  backendFlags = builtins.map (
    b: if builtins.elem b withBackends then "-D${b}=enabled" else "-D${b}=disabled"
  ) (builtins.attrNames backends);
in

# check that given window system is valid
assert lib.assertOneOf "withWindowSystem" withWindowSystem (builtins.attrNames windowSystems);
# check that every given backend is valid
assert builtins.all (
  b: lib.assertOneOf "each backend" b (builtins.attrNames backends)
) withBackends;

stdenv.mkDerivation {
  pname = "imv";
  version = "4.5.0";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "imv";
    rev = "08b9d317957ac9a184d1639c28b95eadd3f0e3d2";
    hash = "sha256-BH8Ub/0yVIA0BM9fKdPwBUYBH5u9p6ZFUBu9kL9Njls=";
  };

  mesonFlags = [
    "-Dwindows=${withWindowSystem}"
    "-Dtest=enabled"
    "-Dman=enabled"
  ]
  ++ backendFlags;

  strictDeps = true;

  nativeBuildInputs = [
    asciidoc
    docbook_xsl
    libxslt
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    cmocka
    icu75
    libxkbcommon
    pango
    inih
  ]
  ++ windowSystems."${withWindowSystem}"
  ++ builtins.map (b: backends."${b}") withBackends;

  postInstall = ''
    install -Dm644 ../files/imv.desktop $out/share/applications/
  '';

  postFixup = lib.optionalString (withWindowSystem == "all") ''
    # The `bin/imv` script assumes imv-wayland or imv-x11 in PATH,
    # so we have to fix those to the binaries we installed into the /nix/store

    substituteInPlace "$out/bin/imv" \
      --replace-fail "imv-wayland" "$out/bin/imv-wayland" \
      --replace-fail "imv-x11" "$out/bin/imv-x11"
  '';

  doCheck = true;

  meta = with lib; {
    description = "Command line image viewer for tiling window managers";
    homepage = "https://sr.ht/~exec64/imv/";
    license = licenses.mit;
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
    mainProgram = "imv";
  };
}
