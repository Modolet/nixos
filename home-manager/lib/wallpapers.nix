{ config }:
let
  inherit (config.lib.misc) hexToRGBA;
in
{
  imports = [
    ../../lib/wallpaper/goNord.nix
    ../../lib/wallpaper/lutgen.nix
    ../../lib/wallpaper/buildWallpaper.nix
    ../../lib/wallpaper/effects.nix
  ];

  inherit (import ../../lib/wallpaper {
    pkgs = config.pkgs;
    inherit hexToRGBA;
  })
    getWallpaper applyEffects generateWallpaper setWallpaper blurWallpaper
    goNord lutgen;
}