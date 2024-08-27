{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt.de";
  version = "2024-08-27";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "c6cabd7eb2dda87ace23a2152f62454db0be752a";
    hash = "sha256-GlI2D4W7je4u9pRkCClp8hGik0cVH4dL54lfEoaAPbU=";
  };

  npmDepsHash = "sha256-DyjnXK6kQk1g2kNNxREu/2XwKXLJHHZ0I0BpIUML1/w=";

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
