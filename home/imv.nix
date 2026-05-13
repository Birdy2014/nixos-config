{ pkgs, ... }:

{
  programs.imv = {
    enable = true;
    package = pkgs.imv.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        (pkgs.fetchpatch {
          url = "https://github.com/Birdy2014/imv/commit/3af0fdda375226718d11396e6df93393d57812b2.patch";
          hash = "sha256-hNC3TEkqKnlpoAP8B8J3qRlmfznD65bl84Fi6pkQJcw=";
        })
      ];
    });

    settings = {
      options.overlay_font = "monospace:10";
      binds = {
        "<Shift+K>" = "prev";
        "<Shift+J>" = "next";

        "o" = "";
        "i" = "overlay";
        "d" = "";
        "<plus>" = "zoom 1";
        "<minus>" = "zoom -1";
        "<Shift+R>" = "rotate by 90";
      };
    };
  };
}
