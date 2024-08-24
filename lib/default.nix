{ lib, nix-colorizer }:
let
  hexDigitToDec = digit:
    let value = lib.strings.charToInt (lib.toLower digit);
    in if value >= 48 && value <= 57 then value - 48 else value - 87;

  hexToDec = hex:
    let len = lib.stringLength hex;
    in if len == 0 then
      0
    else
      ((hexDigitToDec (lib.substring (len - 1) 1 hex)) + 16
        * hexToDec (lib.substring 0 (len - 1) hex));

  decDigitToHex = digit:
    if digit < 10 then
      toString digit
    else
      lib.elemAt [ "a" "b" "c" "d" "e" "f" ] (digit - 10);

  decToHexHelper = dec:
    if dec == 0 then
      ""
    else
      (decToHexHelper (dec / 16) + decDigitToHex (lib.mod dec 16));

  decToHex = dec: if dec == 0 then "0" else (decToHexHelper dec);

  mix = oklch1: oklch2: ratio:
    let interpolate = n: m: n * (1 - ratio) + m * ratio;
    in {
      L = interpolate oklch1.L oklch2.L;
      C = interpolate oklch1.C oklch2.C;
      h = interpolate oklch1.h oklch2.h;
    };
in { inherit hexToDec decToHex mix; }
