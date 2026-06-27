{
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  node-gyp,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-06-27";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "282b3fb2ee3e8564cb07ae399b58bf4a10a9ab35";
    hash = "sha256-i4xewKeyCfsT3q4kfBh1ZbwmsDkxsHacr8r3p0sj13o=";
  };

  npmDepsHash = "sha256-3FedVl87xVeBheZH8ELyClW5JwxbOGAtxU3Cq5W9u8U=";

  nativeBuildInputs = [
    # for sharp
    node-gyp
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
