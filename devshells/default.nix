{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.rust =
        let
          rustPackages = with pkgs; [
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
            xorg.libxcb
            vulkan-loader
            mesa
            libglvnd
            egl-wayland
            xorg.libXext
          ];
        in
        pkgs.mkShell {
          packages = rustPackages;
          shellHook = ''
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath rustPackages}:$LD_LIBRARY_PATH"
          '';
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
