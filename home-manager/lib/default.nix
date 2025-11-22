{ config, ... }:
{
  imports = [
    ./wallpapers.nix
    ./colorScheme.nix
    ./swhkd.nix
    ./misc.nix
  ];

  # Export all library functions through config.lib
  config.lib = {
    # These will be defined by the imported modules above
    wallpapers = import ./wallpapers.nix { inherit config; };
    colorScheme = import ./colorScheme.nix { inherit config; };
    swhkd = import ./swhkd.nix;
    misc = import ./misc.nix;
  };
}