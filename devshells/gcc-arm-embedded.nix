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
    in
    {
      devShells.gcc-arm-embedded = pkgs.mkShell {
        packages = [
          gccArm
          pkgs.cmake
          pkgs.ninja
        ];
        ARM_NONE_EABI_SYSROOT = sysroot;
        C_INCLUDE_PATH = cIncludePath;
        CPLUS_INCLUDE_PATH = cxxIncludePath;
        CPATH = cxxIncludePath;
      };
    };
}
