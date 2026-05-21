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
    rev = "ff28262da5a3a8c61daef5a6d09a508af4e56eec";
    hash = "sha256-fntyZQNmhYQyVUcUqQTndhclgryWIxTKA6JEKnZ8+j8=";
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
