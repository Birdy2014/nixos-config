{ ... }:

{
  projectRootFile = "flake.nix";
  programs = {
    nixfmt.enable = true;
    stylua = {
      enable = true;
      settings.indent_type = "Spaces";
    };
    black.enable = true;
  };
}
