{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
    python314
    rustup
    gcc-arm-embedded
    cargo-xwin
    cmake
    ninja
    gcc
    stm32cubemx
    probe-rs-tools
    pyocd
    stlink
    jetbrains.clion
    qtcreator
  ];
}
