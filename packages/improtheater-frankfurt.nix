{
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  node-gyp,
}:

buildNpmPackage {
  pname = "improtheater-frankfurt";
  version = "2026-10-16";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "improtheater-frankfurt.de";
    rev = "d38dea6b04ff4d75196006a75360c23a2f052369";
    hash = "sha256-ISNkSoZLM3IPK2MdWLU+2bd2NryzmVIyIJO4rha4DuU=";
  };

  npmDepsHash = "sha256-SxCbBNAEypX+66dvFMByhXEUk4kH78gHmaglDU11Bkw=";

  nativeBuildInputs = [
    # for sharp
    node-gyp
  ];

  nodejs = nodejs_24;

  npmInstallFlags = [ "--build-from-source" ];
  makeCacheWritable = true;
}
