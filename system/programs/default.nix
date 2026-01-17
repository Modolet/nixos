{ pkgs, ... }:
{
  imports = [
    ./home-manager.nix
    ./virtualization.nix
  ];

  environment.systemPackages = [
    pkgs.probe-rs-tools
  ];
}
