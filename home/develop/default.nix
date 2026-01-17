{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
    stm32cubemx
    pyocd
    stlink
    jetbrains.clion
    qtcreator
    vscode
  ];
}
