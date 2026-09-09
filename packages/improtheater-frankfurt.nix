{
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  node-gyp,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-09-10";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "31a89ff34680b898af02bcc5288ff92ff71fdb50";
    hash = "sha256-kaSW8/alTk6fHkyU+kaXGbH1QqCPFKEHb58aBlV/kBA=";
  };

  npmDepsHash = "sha256-SNMuZhYmacT8yY4fZe5bQ+avVGS1iW816AlNWg+x4FQ=";

  nativeBuildInputs = [
    # for sharp
    node-gyp
  ];

  nodejs = nodejs_24;

  npmInstallFlags = [ "--build-from-source" ];
  makeCacheWritable = true;
}
