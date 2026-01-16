{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nautilus
    seafile-client
    evolution
    wineWowPackages.waylandFull
  ];

}
