{ self, ... }:
{
  imports = [
    ./core
    ./programs
    ./network
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = builtins.attrValues self.overlays;
  nix.settings.extra-experimental-features = [
    "nix-command"
    "flakes"
  ];
}
