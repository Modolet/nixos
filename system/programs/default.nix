{ pkgs, ... }:
{
  imports = [
    ./home-manager.nix
    ./virtualization.nix
  ];

  environment.systemPackages = with pkgs; [
    probe-rs-tools
    usbutils
    pciutils
    openlist
  ];
}
