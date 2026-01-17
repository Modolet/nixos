_: {
  perSystem =
    { pkgs, ... }:
    let
      llvmPkgs =
        if pkgs ? llvmPackages_21 then
          pkgs.llvmPackages_21
        else
          pkgs.llvmPackages;
      clangdWrapper = pkgs.runCommand "clangd-gcc-arm-embedded" { } ''
        mkdir -p "$out/bin"
        cat > "$out/bin/clangd" <<'EOF'
        #!${pkgs.runtimeShell}
        exec ${llvmPkgs.clang-tools}/bin/clangd \
          --query-driver="${pkgs.gcc-arm-embedded}/bin/arm-none-eabi-*" \
          "$@"
        EOF
        chmod +x "$out/bin/clangd"
      '';
    in
    {
      devShells.gcc-arm-embedded = pkgs.mkShell {
        packages = [
          pkgs.gcc-arm-embedded
          pkgs.cmake
          pkgs.ninja
          clangdWrapper
        ];
      };
    };
}
