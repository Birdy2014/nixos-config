{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2024-10-02";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "ffb303fccbd0d308361590d7b8f4b7f4836da3ea";
    hash = "sha256-tIV4SNe4cbgdci+CPNFQsHV09GekvxnQaJASF7GPfkk=";
  };

  npmDepsHash = "sha256-3OtRRZCA5KGeMg9N7ZxJx6wYJxhcGurREDGcwjRUIvk=";

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

  npmInstallFlags = [ "--build-from-source" ];
  makeCacheWritable = true;
}
