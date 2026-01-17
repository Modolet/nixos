_: {
  perSystem =
    { pkgs, ... }:
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
    {
      devShells.rust = pkgs.mkShell {
        packages = rustPackages;
        shellHook = ''
          export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath rustPackages}:$LD_LIBRARY_PATH"
        '';
      };
    };
}
