{ stdenv, pkgs, ... }:

stdenv.mkDerivation {
  pname = "xdg-open";
  version = "0.0.1";

  propagatedBuildInputs = [ pkgs.python3 ];
  dontUnpack = true;
  installPhase = "install -Dm755 ${./xdg-open.py} $out/bin/xdg-open";

  meta = {
    description = "My xdg-open replacement";
    priority = -10;
  };
}
