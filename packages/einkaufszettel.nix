{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "einkaufszettel";
  version = "2025-02-17";

  src = fetchFromGitHub {
    owner = "Birdy2014";
    repo = "einkaufszettel";
    rev = "f92905f2006320cd2b526a238163659df1d50fb8";
    hash = "sha256-H4AZMJPLrJdjBnCazzah+zTUZNaU04e59oXGJCBzKDg=";
  };

  cargoHash = "sha256-8QPwt2FTXV6H692RFQjrJp3BHi8JxIEpFDDv3wR60ZY=";
}
