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
        set(CMAKE_C_COMPILER cc)
        set(CMAKE_CXX_COMPILER c++)
        set(CMAKE_LINKER lld-link)
        set(CMAKE_RC_COMPILER llvm-rc)
        set(CMAKE_AR llvm-lib)
      '';
      winWrappers = pkgs.runCommand "win-clang-wrappers" { } ''
        mkdir -p "$out/bin"
        cat > "$out/bin/cc" <<'EOF'
        #!${pkgs.runtimeShell}
        set -euo pipefail
        WIN_SDK_VERSION="''${WIN_SDK_VERSION:-${winSdkVersion}}"
        WIN_CRT_VERSION="''${WIN_CRT_VERSION:-${winCrtVersion}}"
        XWIN_SYSROOT="''${XWIN_SYSROOT:?XWIN_SYSROOT not set}"

        resolve_win_target() {
          if [ -n "''${WIN_TARGET:-}" ]; then
            echo "$WIN_TARGET"
            return
          fi
          local dir="$PWD"
          while [ "$dir" != "/" ]; do
            if [ -f "$dir/CMakeCache.txt" ]; then
              local target
              target="$(awk -F= '/^WIN_TARGET:STRING=/{print $2; exit}' "$dir/CMakeCache.txt")"
              if [ -n "$target" ]; then
                echo "$target"
                return
              fi
            fi
            dir="$(dirname "$dir")"
          done
          echo "x86_64-pc-windows-msvc"
        }

        normalize_win_target() {
          case "$1" in
            i686) echo "i686-pc-windows-msvc" ;;
            x86_64) echo "x86_64-pc-windows-msvc" ;;
            *) echo "$1" ;;
          esac
        }

        WIN_TARGET="$(normalize_win_target "$(resolve_win_target)")"
        export WIN_TARGET

        case "$WIN_TARGET" in
          i686*) WIN_SDK_ARCH="x86"; MACHINE_FLAG="/machine:x86" ;;
          x86_64*) WIN_SDK_ARCH="x86_64"; MACHINE_FLAG="/machine:x64" ;;
          *) echo "Unsupported WIN_TARGET: $WIN_TARGET" >&2; exit 1 ;;
        esac

        XWIN_CRT_DIR="$XWIN_SYSROOT/VC/Tools/MSVC/$WIN_CRT_VERSION"
        XWIN_SDK_DIR="$XWIN_SYSROOT/WindowsKits/10"

        include_paths=(
          "$XWIN_CRT_DIR/include"
          "$XWIN_SDK_DIR/Include/$WIN_SDK_VERSION/shared"
          "$XWIN_SDK_DIR/Include/$WIN_SDK_VERSION/um"
          "$XWIN_SDK_DIR/Include/$WIN_SDK_VERSION/ucrt"
          "$XWIN_SDK_DIR/Include/$WIN_SDK_VERSION/winrt"
          "$XWIN_SDK_DIR/Include/$WIN_SDK_VERSION/cppwinrt"
        )
        lib_paths=(
          "$XWIN_CRT_DIR/lib/$WIN_SDK_ARCH"
          "$XWIN_SDK_DIR/Lib/$WIN_SDK_VERSION/ucrt/$WIN_SDK_ARCH"
          "$XWIN_SDK_DIR/Lib/$WIN_SDK_VERSION/um/$WIN_SDK_ARCH"
        )
        join_by() {
          local IFS="$1"
          shift
          echo "$*"
        }
        INCLUDE="$(join_by ';' "''${include_paths[@]}")''${INCLUDE:+;$INCLUDE}"
        LIB="$(join_by ';' "''${lib_paths[@]}")''${LIB:+;$LIB}"
        export INCLUDE LIB

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

        exec ${llvmPkgs.clang-unwrapped}/bin/clang-cl \
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

        cat > "$out/bin/lld-link" <<'EOF'
        #!${pkgs.runtimeShell}
        set -euo pipefail
        WIN_SDK_VERSION="''${WIN_SDK_VERSION:-${winSdkVersion}}"
        WIN_CRT_VERSION="''${WIN_CRT_VERSION:-${winCrtVersion}}"
        XWIN_SYSROOT="''${XWIN_SYSROOT:?XWIN_SYSROOT not set}"

        resolve_win_target() {
          if [ -n "''${WIN_TARGET:-}" ]; then
            echo "$WIN_TARGET"
            return
          fi
          local dir="$PWD"
          while [ "$dir" != "/" ]; do
            if [ -f "$dir/CMakeCache.txt" ]; then
              local target
              target="$(awk -F= '/^WIN_TARGET:STRING=/{print $2; exit}' "$dir/CMakeCache.txt")"
              if [ -n "$target" ]; then
                echo "$target"
                return
              fi
            fi
            dir="$(dirname "$dir")"
          done
          echo "x86_64-pc-windows-msvc"
        }

        normalize_win_target() {
          case "$1" in
            i686) echo "i686-pc-windows-msvc" ;;
            x86_64) echo "x86_64-pc-windows-msvc" ;;
            *) echo "$1" ;;
          esac
        }

        WIN_TARGET="$(normalize_win_target "$(resolve_win_target)")"
        export WIN_TARGET

        case "$WIN_TARGET" in
          i686*) WIN_SDK_ARCH="x86"; MACHINE_FLAG="/machine:x86" ;;
          x86_64*) WIN_SDK_ARCH="x86_64"; MACHINE_FLAG="/machine:x64" ;;
          *) echo "Unsupported WIN_TARGET: $WIN_TARGET" >&2; exit 1 ;;
        esac

        XWIN_CRT_DIR="$XWIN_SYSROOT/VC/Tools/MSVC/$WIN_CRT_VERSION"
        XWIN_SDK_DIR="$XWIN_SYSROOT/WindowsKits/10"
        lib_paths=(
          "$XWIN_CRT_DIR/lib/$WIN_SDK_ARCH"
          "$XWIN_SDK_DIR/Lib/$WIN_SDK_VERSION/ucrt/$WIN_SDK_ARCH"
          "$XWIN_SDK_DIR/Lib/$WIN_SDK_VERSION/um/$WIN_SDK_ARCH"
        )
        join_by() {
          local IFS="$1"
          shift
          echo "$*"
        }
        LIB="$(join_by ';' "''${lib_paths[@]}")''${LIB:+;$LIB}"
        export LIB

        extra_args=(
          "/libpath:''${XWIN_SDK_DIR}/Lib/''${WIN_SDK_VERSION}/um/''${WIN_SDK_ARCH}"
          "/libpath:''${XWIN_SDK_DIR}/Lib/''${WIN_SDK_VERSION}/ucrt/''${WIN_SDK_ARCH}"
          "/libpath:''${XWIN_CRT_DIR}/lib/''${WIN_SDK_ARCH}"
        )
        case " $* " in
          *" /machine:"*) ;;
          *) extra_args+=("$MACHINE_FLAG") ;;
        esac

        exec ${llvmPkgs.lld}/bin/lld-link \
          "''${extra_args[@]}" \
          "$@"
        EOF
        chmod +x "$out/bin/lld-link"

        cat > "$out/bin/link" <<'EOF'
        #!${pkgs.runtimeShell}
        exec lld-link "$@"
        EOF
        chmod +x "$out/bin/link"
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
