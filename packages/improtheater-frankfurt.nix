{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt.de";
  version = "2024-06-22";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "3114a1aa1c2e18c0446802fe4a6df3ec5a8035e4";
    hash = "sha256-nCPcT4sybUaHFbkLSWEF48eA2rH5eWwYBA3gMlWKxJY=";
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
