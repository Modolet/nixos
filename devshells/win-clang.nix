{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      winSdkVersion = "10.0.26100";
      winCrtVersion = "14.44.17.14";
      winPackages = with pkgs; [
        clang
        lld
        llvm
        xwin
        cmake
        ninja
        pkg-config
      ];
      winToolchainFile = pkgs.writeText "win-clang-toolchain.cmake" ''
        set(CMAKE_SYSTEM_NAME Windows)
        set(CMAKE_C_COMPILER clang-cl)
        set(CMAKE_CXX_COMPILER clang-cl)
        set(CMAKE_LINKER lld-link)
        set(CMAKE_RC_COMPILER llvm-rc)
        set(CMAKE_C_FLAGS_INIT "--target=$ENV{WIN_TARGET} --winsysroot=$ENV{XWIN_SYSROOT}")
        set(CMAKE_CXX_FLAGS_INIT "--target=$ENV{WIN_TARGET} --winsysroot=$ENV{XWIN_SYSROOT}")
        set(CMAKE_EXE_LINKER_FLAGS_INIT "--target=$ENV{WIN_TARGET} --winsysroot=$ENV{XWIN_SYSROOT}")
        set(CMAKE_FIND_ROOT_PATH "$ENV{XWIN_SYSROOT}")
        set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
        set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
        set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
        set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
      '';
      winWrappers = pkgs.runCommand "win-clang-wrappers" { } ''
        mkdir -p "$out/bin"
        cat > "$out/bin/cc" <<'EOF'
        #!${pkgs.runtimeShell}
        exec clang-cl --target="''${WIN_TARGET:-x86_64-pc-windows-msvc}" \
          --winsysroot="''${XWIN_SYSROOT}" "$@"
        EOF
        chmod +x "$out/bin/cc"

        cat > "$out/bin/c++" <<'EOF'
        #!${pkgs.runtimeShell}
        exec clang-cl --target="''${WIN_TARGET:-x86_64-pc-windows-msvc}" \
          --winsysroot="''${XWIN_SYSROOT}" "$@"
        EOF
        chmod +x "$out/bin/c++"

        cat > "$out/bin/cl" <<'EOF'
        #!${pkgs.runtimeShell}
        exec clang-cl --target="''${WIN_TARGET:-x86_64-pc-windows-msvc}" \
          --winsysroot="''${XWIN_SYSROOT}" "$@"
        EOF
        chmod +x "$out/bin/cl"
      '';
      winSysroot = pkgs.stdenvNoCC.mkDerivation {
        pname = "xwin-sysroot";
        inherit (pkgs.xwin) version;
        nativeBuildInputs = [ pkgs.xwin ];
        dontUnpack = true;
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-5L4WHIxe94O7CrFdJPYSJ4g70tldCpyRpN7ijSd/bsc=";
        installPhase = ''
          export XWIN_ACCEPT_LICENSE=1
          export XWIN_CACHE_DIR="$TMPDIR/xwin-cache"
          mkdir -p "$XWIN_CACHE_DIR"

          xwin --accept-license \
            --cache-dir "$XWIN_CACHE_DIR" \
            --arch x86 --arch x86_64 \
            --variant desktop \
            --sdk-version ${winSdkVersion} \
            --crt-version ${winCrtVersion} \
            --include-debug-runtime \
            download

          xwin --accept-license \
            --cache-dir "$XWIN_CACHE_DIR" \
            --arch x86 --arch x86_64 \
            --variant desktop \
            --sdk-version ${winSdkVersion} \
            --crt-version ${winCrtVersion} \
            splat \
            --output "$out" \
            --use-winsysroot-style \
            --include-debug-libs \
            --copy
        '';
      };
    in
    {
      packages.win-clang-sysroot = winSysroot;
      devShells.win-clang = pkgs.mkShell {
        stdenv = pkgs.stdenvNoCC;
        packages = [ winWrappers ] ++ winPackages ++ [ winSysroot ];
        XWIN_SYSROOT = "${winSysroot}";
        WIN_TARGET = "x86_64-pc-windows-msvc";
        CMAKE_TOOLCHAIN_FILE = "${winToolchainFile}";
        CC = "cc";
        CXX = "c++";
        LD = "lld-link";
        AR = "llvm-lib";
        RC = "llvm-rc";
      };
    };
}
