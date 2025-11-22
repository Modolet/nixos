let
  hexToRGBA = color: let
    r = builtins.substring 1 3 color;
    g = builtins.substring 3 5 color;
    b = builtins.substring 5 7 color;
    a = if builtins.stringLength color > 7 then builtins.substring 7 9 color else "ff";
  in "${(builtins.fromTOML "0x${r}").hexToString (builtins.fromTOML "0x${g}").hexToString (builtins.fromTOML "0x${b}").hexToString (builtins.fromTOML "0x${a}").hexToString}";
in
{
  lib.misc = {
    mkGLSLColor = color: "vec4(${hexToRGBA color})";
  };
}