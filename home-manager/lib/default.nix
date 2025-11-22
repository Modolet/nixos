{ config, lib, ... }:
{
  imports = [
    ../../lib/wallpaper
    ../../lib/colorScheme
    ./swhkd.nix
  ];

  # The wallpaper and colorScheme modules will automatically extend config.lib with their functions
  # We only need to manually define swhkd and misc
  config.lib = {
    swhkd = import ./swhkd.nix;
    misc = import ./misc.nix { inherit lib; };
  };
}