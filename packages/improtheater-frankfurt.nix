{
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  node-gyp,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-09-21";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "79f31f883f940369aa5e0058fbf18e2efdbd5362";
    hash = "sha256-uasGVjjtS7x+Zj01xvbXiGBC9GlU4za7mFd435dcEwE=";
  };

  npmDepsHash = "sha256-BU1seAEPxef9KVRDyIV+BcDdRsXd7saMaOwdS5k8YJU=";

  nativeBuildInputs = [
    # for sharp
    node-gyp
  ];

  nodejs = nodejs_24;

  npmInstallFlags = [ "--build-from-source" ];
  makeCacheWritable = true;
}
