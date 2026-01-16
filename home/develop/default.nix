{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
    python314
    rustup
    gcc-arm-embedded
    cargo-xwin
    clang
    llvm
    cmake
    ninja
  ];
}
