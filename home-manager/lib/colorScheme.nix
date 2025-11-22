{ config }:
let
  inherit (config.lib.misc) hexToRGBA;
in
{
  imports = [
    ../../lib/colorScheme/buildColorScheme.nix
  ];

  inherit (import ../../lib/colorScheme {
    pkgs = config.pkgs;
    inherit hexToRGBA;
  })
    buildColorScheme convertColorScheme generateColorScheme buildSpecialisation;
}