{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        rustc
        cargo
        rustfmt
        clippy
        rust-analyzer
      ];
    };
  };
}
