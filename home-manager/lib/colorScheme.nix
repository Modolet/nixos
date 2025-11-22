{ config, pkgs, ... }:
let
  inherit (config.lib.misc) hexToRGBA;
in
import ../../lib/colorScheme {
  inherit pkgs hexToRGBA;
}