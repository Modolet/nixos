{ self, ... }:
{
  imports = [
    ./core
    ./programs
    ./network
    ./bluetooth
  ];
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];
    overlays = builtins.attrValues self.overlays;
  };
  nix.settings.extra-experimental-features = [
    "nix-command"
    "flakes"
  ];
}
