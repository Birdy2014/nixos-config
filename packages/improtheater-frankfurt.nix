{
  buildNpmPackage,
  fetchFromGitHub,
  nodePackages,
  nodejs_20,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-02-15";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "61e1910afad9971610cfa48318541c58a7bc61f6";
    hash = "sha256-8HPVvVuSPj+BThK4TFx+xvFOmZuoXGAohA4dUnYrdVo=";
  };

  npmDepsHash = "sha256-/XPgwSgEI8c4gDnd/WTA3GkSjiyRzRXXwtzo/WsUipg=";

  nativeBuildInputs = [
    # for sharp
    nodePackages.node-gyp
  ];

  nodejs = nodejs_20;

  dontNpmBuild = true;

  # Reduce closure size
  postInstall = ''
    prefix="$out/lib/node_modules/improtheater-frankfurt/node_modules"
    rm $prefix/better-sqlite3/build/Makefile
    rm $prefix/better-sqlite3/build/config.gypi
    rm $prefix/better-sqlite3/build/better_sqlite3.target.mk
    rm $prefix/better-sqlite3/build/test_extension.target.mk
    rm -r $prefix/better-sqlite3/build/deps
    rm -r $prefix/better-sqlite3/build/Release/.deps
  '';

  npmInstallFlags = [ "--build-from-source" ];
  makeCacheWritable = true;
}
