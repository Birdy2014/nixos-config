{
  buildNpmPackage,
  fetchFromGitHub,
  nodePackages,
  nodejs_24,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-05-12";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "5473d64d4ab28831dd18b0fc9970566111300e9d";
    hash = "sha256-3kuSXGRb3k/p36fn4IWEcqnU3S7ynMONLE01y1XLBbk=";
  };

  npmDepsHash = "sha256-9n3UYAJFOCEEGH68ufS/fWSq0i2L/BMldYv5959xW9c=";

  nativeBuildInputs = [
    # for sharp
    nodePackages.node-gyp
  ];

  nodejs = nodejs_24;

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
