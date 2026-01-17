{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    nautilus
    seafile-client
    evolution
    wineWowPackages.waylandFull
    xsettingsd
    inputs.winapps.packages.${pkgs.system}.winapps
    inputs.winapps.packages.${pkgs.system}.winapps-launcher
  ];

}
