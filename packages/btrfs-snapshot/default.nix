{
  stdenvNoCC,
  makeWrapper,
  python3,
  lib,
  btrfs-progs,
}:

stdenvNoCC.mkDerivation {
  name = "btrfs-snapshot";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];
  dontUnpack = true;

  installPhase = ''
    install -Dm755 ${./btrfs-snapshot.py} $out/bin/btrfs-snapshot
    wrapProgram $out/bin/btrfs-snapshot \
      --prefix PATH : ${lib.makeBinPath [ btrfs-progs ]}
  '';

  meta.mainProgram = "btrfs-snapshot";
}
