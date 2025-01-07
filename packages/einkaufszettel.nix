{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "einkaufszettel";
  version = "2025-01-07";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "einkaufszettel";
    rev = "f6438c27045b916494213f4d394967b11e7a5ee3";
    hash = "sha256-WWA9xkhQs7QK9+8bi1lVXKDw3Hfx+WRQZSbHGpriTlc=";
  };

  cargoHash = "sha256-8QPwt2FTXV6H692RFQjrJp3BHi8JxIEpFDDv3wR60ZY=";
}
