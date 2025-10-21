{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_20,
  google-fonts,
  makeWrapper,
}:

buildNpmPackage {
  pname = "improglycerin";
  version = "2025-10-22";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improglycerin.de";
    rev = "051e40cd68c5a5bad1a6b59fee680f7f73e008d1";
    hash = "sha256-0Ru7PCFXAVkuHeIjtf1ZL8GNneUbW1nZFfgtpu4tGR0=";
  };

  npmDepsHash = "sha256-rV5r88pNBA2qZaXgW8L03AIKkzVMhY9QRkn10Xsgs84=";

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

    makeWrapper ${lib.getExe nodejs_20} $out/bin/improglycerin.de \
      --add-flags "$out/share/improglycerin.de/server.js"

    runHook postInstall
  '';

  meta.mainProgram = "improglycerin.de";
}
