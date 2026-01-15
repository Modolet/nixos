{ pkgs, ... }:
{
  imports = [
    ./musicfox.nix
  ];

  home.packages = with pkgs; [
    neovide
    vlc
    obs-studio
  ];
}
