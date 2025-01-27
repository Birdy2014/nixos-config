{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "einkaufszettel";
  version = "2025-01-27";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "einkaufszettel";
    rev = "963ab400ac1c0c4de5bebf5a8a93ac568aa1eee9";
    hash = "sha256-w1qmszuskB4nkKuLNTQ7KugfzIkf+IqDu8IJJH0QVlY=";
  };

  cargoHash = "sha256-8QPwt2FTXV6H692RFQjrJp3BHi8JxIEpFDDv3wR60ZY=";
}
