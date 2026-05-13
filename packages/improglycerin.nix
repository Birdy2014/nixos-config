{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  makeWrapper,
}:

let
  roboto-fonts = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "d5ea3092960d3d5db0b7a9890c828bafbf159c51";
    hash = "sha256-D6mDh0sT8Q7eyeXvOf1wuTevteP7Z3J+r9LXUHzwRnk=";
    rootDir = "ofl/roboto";
  };
in
buildNpmPackage rec {
  pname = "improglycerin";
  version = "2026-04-29";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improglycerin.de";
    rev = "8ad48545c0e307ffd610bd59fcd221525e8a5697";
    hash = "sha256-bYFTQpNXOtnxQEAfwrcnGGC90WR6gcGTDfw51KyA5v8=";
  };

  npmDepsHash = "sha256-7xxhsQQ6e9nnSLG1nlUna6Vkvq/cX+37wHqaWCMZT5M=";

  nodejs = nodejs_24;

  postPatch = ''
    substituteInPlace app/layout.tsx \
      --replace-fail 'import { Roboto } from "next/font/google";' 'import localFont from "next/font/local";' \
      --replace-fail $'const roboto = Roboto({\n  subsets: ["latin"],\n});' 'const roboto = localFont({ src: "../public/Roboto.ttf" });'
  '';

  preBuild = ''
    cp "${roboto-fonts}/Roboto[wdth,wght].ttf" "public/Roboto.ttf"
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

    makeWrapper ${lib.getExe nodejs_24} $out/bin/improglycerin.de \
      --add-flags "$out/share/improglycerin.de/server.js"

    runHook postInstall
  '';

  meta.mainProgram = "improglycerin.de";
}
