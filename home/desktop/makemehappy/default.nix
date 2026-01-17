{ pkgs, ... }:
{
  imports = [
    ./musicfox.nix
  ];

  home.packages = with pkgs; [
    neovide
    kdePackages.kdenlive
    obs-studio
    clash-verge-rev
    wpsoffice-cn
    wemeet
    file-roller
    evince
    loupe
  ];

}
