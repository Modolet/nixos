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
