_: {
  perSystem =
    { pkgs, ... }:
    let
      winSdkVersion = "10.0.26100";
      winCrtVersion = "14.44.17.14";
      llvmPkgs =
        if pkgs ? llvmPackages_21 then
          pkgs.llvmPackages_21
        else
          pkgs.llvmPackages;
      winPackages = [
        llvmPkgs.clang-unwrapped
        llvmPkgs.lld
        llvmPkgs.llvm
        pkgs.xwin
        pkgs.cmake
        pkgs.ninja
        pkgs.pkg-config
      ];
      winToolchainFile = pkgs.writeText "win-clang-toolchain.cmake" ''
        set(CMAKE_SYSTEM_NAME Windows)
        set(WIN_TARGET "$ENV{WIN_TARGET}")
        if(NOT WIN_TARGET)
          set(WIN_TARGET "x86_64-pc-windows-msvc")
        endif()

        if(WIN_TARGET MATCHES "i686")
          set(WIN_SDK_ARCH "x86")
          set(MACHINE_FLAG "/machine:x86")
        elseif(WIN_TARGET MATCHES "x86_64")
          set(WIN_SDK_ARCH "x86_64")
          set(MACHINE_FLAG "/machine:x64")
        else()
          message(FATAL_ERROR "Unsupported WIN_TARGET: ''${WIN_TARGET}")
        endif()

        set(WIN_SDK_VERSION "$ENV{WIN_SDK_VERSION}")
        set(WIN_CRT_VERSION "$ENV{WIN_CRT_VERSION}")
        set(XWIN_SYSROOT "$ENV{XWIN_SYSROOT}")
        set(XWIN_CRT_DIR "''${XWIN_SYSROOT}/VC/Tools/MSVC/''${WIN_CRT_VERSION}")
        set(XWIN_SDK_DIR "''${XWIN_SYSROOT}/WindowsKits/10")

        set(CMAKE_C_COMPILER clang-cl)
        set(CMAKE_CXX_COMPILER clang-cl)
        set(CMAKE_C_LINK_EXECUTABLE lld-link)
        set(CMAKE_CXX_LINK_EXECUTABLE lld-link)
        set(CMAKE_LINKER lld-link)
        set(CMAKE_RC_COMPILER llvm-rc)

        set(CLANG_MSVC_FLAGS "/vctoolsdir \"''${XWIN_CRT_DIR}\" /winsdkdir \"''${XWIN_SDK_DIR}\" --target=''${WIN_TARGET}")
        set(CMAKE_C_FLAGS_INIT "''${CLANG_MSVC_FLAGS}")
        set(CMAKE_CXX_FLAGS_INIT "''${CLANG_MSVC_FLAGS}")
        set(CMAKE_RC_FLAGS_INIT "''${CLANG_MSVC_FLAGS}")

        set(LINKER_FLAGS "-libpath:''${XWIN_SDK_DIR}/Lib/''${WIN_SDK_VERSION}/um/''${WIN_SDK_ARCH}")
        set(LINKER_FLAGS "''${LINKER_FLAGS} -libpath:''${XWIN_SDK_DIR}/Lib/''${WIN_SDK_VERSION}/ucrt/''${WIN_SDK_ARCH}")
        set(LINKER_FLAGS "''${LINKER_FLAGS} -libpath:''${XWIN_CRT_DIR}/lib/''${WIN_SDK_ARCH}")
        set(LINKER_FLAGS "''${LINKER_FLAGS} ''${MACHINE_FLAG}")
        set(CMAKE_EXE_LINKER_FLAGS_INIT "''${LINKER_FLAGS}")
        set(CMAKE_SHARED_LINKER_FLAGS_INIT "''${LINKER_FLAGS}")
        set(CMAKE_MODULE_LINKER_FLAGS_INIT "''${LINKER_FLAGS}")

        set(CMAKE_FIND_ROOT_PATH "''${XWIN_SYSROOT}")
        set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
        set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
        set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
        set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
      '';
      winWrappers = pkgs.runCommand "win-clang-wrappers" { } ''
        mkdir -p "$out/bin"
        cat > "$out/bin/cc" <<'EOF'
        #!${pkgs.runtimeShell}
        set -euo pipefail
        WIN_TARGET="''${WIN_TARGET:-x86_64-pc-windows-msvc}"
        WIN_SDK_VERSION="''${WIN_SDK_VERSION:-${winSdkVersion}}"
        WIN_CRT_VERSION="''${WIN_CRT_VERSION:-${winCrtVersion}}"
        XWIN_SYSROOT="''${XWIN_SYSROOT:?XWIN_SYSROOT not set}"

        case "$WIN_TARGET" in
          i686*) WIN_SDK_ARCH="x86"; MACHINE_FLAG="/machine:x86" ;;
          x86_64*) WIN_SDK_ARCH="x86_64"; MACHINE_FLAG="/machine:x64" ;;
          *) echo "Unsupported WIN_TARGET: $WIN_TARGET" >&2; exit 1 ;;
        esac

        XWIN_CRT_DIR="$XWIN_SYSROOT/VC/Tools/MSVC/$WIN_CRT_VERSION"
        XWIN_SDK_DIR="$XWIN_SYSROOT/WindowsKits/10"

        needs_link=1
        for arg in "$@"; do
          case "$arg" in
            -c|/c) needs_link=0 ;;
          esac
        done
        link_args=()
        if [ "$needs_link" -eq 1 ]; then
          link_args=(
            /link
            "/libpath:''${XWIN_SDK_DIR}/Lib/''${WIN_SDK_VERSION}/um/''${WIN_SDK_ARCH}"
            "/libpath:''${XWIN_SDK_DIR}/Lib/''${WIN_SDK_VERSION}/ucrt/''${WIN_SDK_ARCH}"
            "/libpath:''${XWIN_CRT_DIR}/lib/''${WIN_SDK_ARCH}"
            "$MACHINE_FLAG"
          )
        fi

        exec clang-cl \
          /vctoolsdir "$XWIN_CRT_DIR" \
          /winsdkdir "$XWIN_SDK_DIR" \
          --target="$WIN_TARGET" \
          -fuse-ld=lld \
          "$@" \
          "''${link_args[@]}"
        EOF
        chmod +x "$out/bin/cc"

        cat > "$out/bin/c++" <<'EOF'
        #!${pkgs.runtimeShell}
        exec cc "$@"
        EOF
        chmod +x "$out/bin/c++"

        cat > "$out/bin/cl" <<'EOF'
        #!${pkgs.runtimeShell}
        exec cc "$@"
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
        outputHash = "sha256-4xm4///FQTt7bwzUIJJkLtDB1wnJjSszv4kPwo474Zg=";
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

          ln -s "$out/Windows Kits" "$out/WindowsKits"
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
        WIN_SDK_VERSION = winSdkVersion;
        WIN_CRT_VERSION = winCrtVersion;
        CMAKE_TOOLCHAIN_FILE = "${winToolchainFile}";
        NIX_CFLAGS_COMPILE = "";
        NIX_CFLAGS_LINK = "";
        NIX_LDFLAGS = "";
        CC = "cc";
        CXX = "c++";
        LD = "lld-link";
        AR = "llvm-lib";
        RC = "llvm-rc";
      };
    };
}
