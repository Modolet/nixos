{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.qt5 = pkgs.mkShell {
        packages = with pkgs; [
          qt5.qtbase
          qt5.qttools
          qt5.qtsvg
          qt5.qtdeclarative
          qt5.qtwayland
          cmake
          ninja
          pkg-config
        ];
      };
    };
}
