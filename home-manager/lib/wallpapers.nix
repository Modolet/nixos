{ config, pkgs, ... }:
let
  inherit (config.lib.misc) hexToRGBA;
in
import ../../lib/wallpaper {
  inherit pkgs hexToRGBA;
}