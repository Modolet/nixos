{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.rust = pkgs.mkShell {
        packages = with pkgs; [
          rustc
          cargo
          rustfmt
          clippy
          rust-analyzer
          pkg-config
          systemd.dev
          wayland
          wayland-protocols
          libxkbcommon
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
          xorg.libXrandr
        ];
      };
      devShells.clang = pkgs.mkShell {
        packages = with pkgs; [
          clang
          clang-tools
          lld
          cmake
          ninja
          pkg-config
        ];
      };
    };
}
