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
  version = "2025-10-20";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "d981f2ba1748fc5b03e602c17b2ff386ae7d5bf0";
    hash = "sha256-Fmj9vBKFKMzC5DJgCsllLXaEOXhf1lyurAR3CFIs4Fk=";
  };

  npmDepsHash = "sha256-e6KIwoJc5jx0nn3mg8d7pGPL0Iyocot/QP1wl0Fme+M=";

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
