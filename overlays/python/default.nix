final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: python-prev: {
      # https://github.com/NixOS/nixpkgs/pull/580486
      fpdf2 = python-prev.fpdf2.overrideAttrs (package-prev: {
        disabledTests = package-prev.disabledTests ++ [ "test_image_with_explicit_dimensions" ];
      });

      # https://github.com/NixOS/nixpkgs/pull/580682
      imageio = python-prev.imageio.overrideAttrs (package-prev: {
        disabledTestPaths = package-prev.disabledTestPaths ++ [
          "tests/test_pillow.py::test_png_16bit"
          "tests/test_pillow_legacy.py::test_png"
        ];
      });

      # https://github.com/NixOS/nixpkgs/pull/569158
      pypdf = python-prev.pypdf.overrideAttrs (package-prev: {
        disabledTests = [
          "test_dictionary_object__read_from_stream__missing_length__limit"
          "test_flatedecode__decode_png_prediction__speed"
        ];
      });
    })
  ];
}
