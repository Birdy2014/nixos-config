# TODO: Remove when waybar 0.10.1 is released

final: prev: {
  waybar = (prev.waybar.overrideAttrs (old: {
    src = final.fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = "3de9e0cbd32c090daedf81fc86b2bf88e060fbce";
      hash = "sha256-gVVRjd1IL0NAbBLiWJAl1xqkX8dLTS+z3xjJFfGaTIk=";
    };
  })).override { wireplumberSupport = false; };
}
