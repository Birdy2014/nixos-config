{ buildNpmPackage, fetchFromGitHub, nodePackages, pkg-config, vips, nodejs_20 }:

buildNpmPackage {
  pname = "improtheater-frankfurt.de";
  version = "2024-08-29";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "c19bfeaa3bbc975bdaf63c2832dde63827571100";
    hash = "sha256-vyR61a35dIuRL2J+fsTdKXC9bZx58cwOXnJ3HKboV64=";
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
