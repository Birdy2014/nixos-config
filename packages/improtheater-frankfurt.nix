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
  version = "2025-08-22";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "3a45e37cd4c7900d07ac66c798712ddacdaf5ba7";
    hash = "sha256-X5UeqZ/Gvab/xHa5KhteTL5bppVFWw+BYdVSp5MmUKU=";
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
