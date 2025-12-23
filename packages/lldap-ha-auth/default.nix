{
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  lib,
  curl,
}:

stdenvNoCC.mkDerivation (attrs: {
  pname = "lldap-ha-auth";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "lldap";
    repo = "lldap";
    rev = "v${attrs.version}";
    hash = "sha256-PoL3RqtDjgU09v+hjsQ8bBj8E6dAOuWrHtZj6qh2pCI=";
    rootDir = "example_configs";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install -m +x ./lldap-ha-auth.sh $out/bin/lldap-ha-auth
    wrapProgram $out/bin/lldap-ha-auth \
      --prefix PATH : ${lib.makeBinPath [ curl ]}
  '';
})
