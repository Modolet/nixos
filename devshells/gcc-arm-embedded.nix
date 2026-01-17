_: {
  perSystem =
    { pkgs, ... }:
    {
      devShells.gcc-arm-embedded = pkgs.mkShell {
        packages = with pkgs; [
          gcc-arm-embedded
          cmake
          ninja
        ];
      };
    };
}
