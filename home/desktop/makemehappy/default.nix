{ pkgs, ... }:
{
  imports = [
    ./musicfox.nix
  ];

  home.packages = with pkgs; [
    neovide
    vlc
    obs-studio
    clash-verge-rev
    wpsoffice-cn
    wemeet
  ];
}
