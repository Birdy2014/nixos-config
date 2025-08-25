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
  version = "2025-08-25";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "47b339ff208ff873c306addb7cdcd0079413134f";
    hash = "sha256-q9rpShCIsav0yCXzMPszxjF3F/Y3/iN4jDN5F6BvWDk=";
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
