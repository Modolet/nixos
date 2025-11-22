{ pkgs, ... }:
{
  lib = {
    swhkd = import ./swhkd.nix;
    colorScheme = import ./colorScheme;
    wallpapers = import ./wallpaper { inherit pkgs; };
    misc = import ./misc.nix;
  };
}