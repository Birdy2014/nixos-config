{
  buildNpmPackage,
  fetchFromGitHub,
  nodePackages,
  pkg-config,
  vips,
  nodejs_20,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2025-08-01";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "a96e0ed2def22b4b65ec0ac17d6c6e57e4d91ed1";
    hash = "sha256-ZmYbm8+5cP+p8ZcrdIXp5/Tyx3G5gaOkTgFYm2B+oWY=";
  };

  npmDepsHash = "sha256-yD/qobpP/V8dQUZ1Bgjg+zj4Phtsgy80nSjfOHyGKTc=";

  nativeBuildInputs = [
    # for bcrypt
    nodePackages.node-pre-gyp

    # for sharp
    pkg-config
  ];

  buildInputs = [
    # for sharp
    vips
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
