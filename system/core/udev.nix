{ pkgs, ... }:
{
  services.udev.packages = with pkgs; [
    probe-rs-udev-rules
  ];
}
