{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
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
