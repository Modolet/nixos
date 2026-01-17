_: {
  perSystem =
    { pkgs, ... }:
    let
      gccArm = pkgs.gcc-arm-embedded;
      gccVersion = gccArm.version;
      sysroot = "${gccArm}/arm-none-eabi";
      gccLib = "${gccArm}/lib/gcc/arm-none-eabi/${gccVersion}";
      cIncludes = [
        "${sysroot}/include"
        "${gccLib}/include"
        "${gccLib}/include-fixed"
      ];
      cxxIncludes = [
        "${sysroot}/include/c++/${gccVersion}"
        "${sysroot}/include/c++/${gccVersion}/arm-none-eabi"
        "${sysroot}/include/c++/${gccVersion}/backward"
      ];
      cIncludePath = pkgs.lib.concatStringsSep ":" cIncludes;
      cxxIncludePath = pkgs.lib.concatStringsSep ":" (cxxIncludes ++ cIncludes);
      llvmPkgs =
        if pkgs ? llvmPackages_21 then
          pkgs.llvmPackages_21
        else
          pkgs.llvmPackages;
      clangdConfig = pkgs.writeTextFile {
        name = "clangd-config-arm-none-eabi";
        destination = "/clangd/config.yaml";
        text = ''
          CompileFlags:
            Add:
              - --target=arm-none-eabi
              - --sysroot=${sysroot}
        '';
      };
      clangdWrapper = pkgs.runCommand "clangd-gcc-arm-embedded" { } ''
        mkdir -p "$out/bin"
        cat > "$out/bin/clangd" <<'EOF'
        #!${pkgs.runtimeShell}
        exec env XDG_CONFIG_HOME="${clangdConfig}" \
          ${llvmPkgs.clang-tools}/bin/clangd \
          --enable-config \
          --query-driver="${gccArm}/bin/arm-none-eabi-*" \
          "$@"
        EOF
        chmod +x "$out/bin/clangd"
      '';
    in
    {
      devShells.gcc-arm-embedded = pkgs.mkShell {
        packages = [
          gccArm
          pkgs.cmake
          pkgs.ninja
          clangdWrapper
        ];
        ARM_NONE_EABI_SYSROOT = sysroot;
        C_INCLUDE_PATH = cIncludePath;
        CPLUS_INCLUDE_PATH = cxxIncludePath;
        CPATH = cxxIncludePath;
      };
    };
}
