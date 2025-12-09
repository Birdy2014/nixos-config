{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_20,
  google-fonts,
  makeWrapper,
}:

buildNpmPackage rec {
  pname = "improglycerin";
  version = "2025-12-10";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improglycerin.de";
    rev = "85176bcc0b823ec4bac1ff01938066aeb7a3e818";
    hash = "sha256-YJXIb2Z+K0Wj+T66iGnCXIpRVERlA0/LE8xg8X/F+I0=";
  };

  npmDepsHash = "sha256-i95ulveOoNMvpm9RXdwvDcE1P+v80MaOs4xzPc/5vCE=";

  nodejs = nodejs_20;

  postPatch = ''
    substituteInPlace app/layout.tsx \
      --replace-fail 'import { Roboto } from "next/font/google";' 'import localFont from "next/font/local";' \
      --replace-fail $'const roboto = Roboto({\n  subsets: ["latin"],\n});' 'const roboto = localFont({ src: "../public/Roboto.ttf" });'
  '';

  preBuild = ''
    cp "${
      google-fonts.override { fonts = [ "Roboto" ]; }
    }/share/fonts/truetype/Roboto[wdth,wght].ttf" "public/Roboto.ttf"
  '';

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r .next/standalone $out/share/improglycerin.de
    cp -r public $out/share/improglycerin.de/public
    chmod +x $out/share/improglycerin.de/server.js

    cp -r .next/static $out/share/improglycerin.de/.next/static

    # This is the ugliest way to move the cache, but it works
    ln -s /tmp/next-cache-${pname}-${version} $out/share/improglycerin.de/.next/cache

    makeWrapper ${lib.getExe nodejs_20} $out/bin/improglycerin.de \
      --add-flags "$out/share/improglycerin.de/server.js"

    runHook postInstall
  '';

  meta.mainProgram = "improglycerin.de";
}
