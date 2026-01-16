{ self, ... }:
{
  imports = [
    ./core
    ./programs
    ./network
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
                "openssl-1.1.1w"
              ];
  nixpkgs.overlays = builtins.attrValues self.overlays;
  nix.settings.extra-experimental-features = [
    "nix-command"
    "flakes"
  ];
}
