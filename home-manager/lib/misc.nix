{ lib }:
{
  hexToRGBA = color:
    let
      hex = lib.strings.removePrefix "#" color;
      r = builtins.substring 0 2 hex;
      g = builtins.substring 2 2 hex;
      b = builtins.substring 4 2 hex;
      toFloat = x: (lib.strings.toIntBase16 x) / 255.0;
    in
    "${toString (toFloat r)} ${toString (toFloat g)} ${toString (toFloat b)}";
}