{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt.de";
  version = "2024-07-27";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "36b2ddcb2d8e2a44e2096f0ec269e60486cd49ea";
    hash = "sha256-X1WlWkdUgYv7O3+btr/9skvuWDsJQnHu8E9+lSwO4K0=";
  };

  npmDepsHash = "sha256-C08wQ7/rJnUE8ukJdIaD4zkPNIQMlPwfmMjexpo+R9M=";

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
