{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
    python314
    rustup
    gcc-arm-embedded
    cargo-xwin
    llvmPackages.bintools
    cmake
    ninja
    gcc
    stm32cubemx
    probe-rs
    pyocd
    stlink
    jetbrains.clion
    qtcreator
  ];
}
