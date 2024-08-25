{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt.de";
  version = "2024-08-25";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "5acd83e2eba5334b95486ba3b924dcfda5d7a0ea";
    hash = "sha256-I8Qe4I7lKoyGQIbEKOMhGGdZzz1dapAJwBr9Y9Smh8A=";
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
