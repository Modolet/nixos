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
      winCommonScript = pkgs.writeText "win-clang-common.sh" (
        builtins.readFile ./win-clang/common.sh
      );
      mkWinWrapper =
        name: text:
        pkgs.writeShellScriptBin name ''
          set -euo pipefail
          : "''${WIN_SDK_VERSION:=${winSdkVersion}}"
          : "''${WIN_CRT_VERSION:=${winCrtVersion}}"
          : "''${XWIN_SYSROOT:?XWIN_SYSROOT not set}"
          CLANG_CL="${llvmPkgs.clang-unwrapped}/bin/clang-cl"
          LLD_LINK="${llvmPkgs.lld}/bin/lld-link"
          source ${winCommonScript}
          ${text}
        '';
      ccWrapper = mkWinWrapper "cc" ''
        win_setup_env "$@"

        target_args=()
        if ! win_args_has_target "$@"; then
          target_args=(--target="''${WIN_TARGET}")
        fi

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
            "''${MACHINE_FLAG}"
          )
        fi

        exec "''${CLANG_CL}" \
          /vctoolsdir "''${XWIN_CRT_DIR}" \
          /winsdkdir "''${XWIN_SDK_DIR}" \
          "''${target_args[@]}" \
          -fuse-ld=lld \
          "$@" \
          "''${link_args[@]}"
      '';
      cxxWrapper = pkgs.writeShellScriptBin "c++" ''
        exec cc "$@"
      '';
      clWrapper = pkgs.writeShellScriptBin "cl" ''
        exec cc "$@"
      '';
      lldLinkWrapper = mkWinWrapper "lld-link" ''
        win_setup_env "$@"

        extra_args=(
          "/libpath:''${XWIN_SDK_DIR}/Lib/''${WIN_SDK_VERSION}/um/''${WIN_SDK_ARCH}"
          "/libpath:''${XWIN_SDK_DIR}/Lib/''${WIN_SDK_VERSION}/ucrt/''${WIN_SDK_ARCH}"
          "/libpath:''${XWIN_CRT_DIR}/lib/''${WIN_SDK_ARCH}"
        )
        case " $* " in
          *" /machine:"*) ;;
          *) extra_args+=("''${MACHINE_FLAG}") ;;
        esac

        exec "''${LLD_LINK}" \
          "''${extra_args[@]}" \
          "$@"
      '';
      linkWrapper = pkgs.writeShellScriptBin "link" ''
        exec lld-link "$@"
      '';
      winWrappers = pkgs.symlinkJoin {
        name = "win-clang-wrappers";
        paths = [
          ccWrapper
          cxxWrapper
          clWrapper
          lldLinkWrapper
          linkWrapper
        ];
      };
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
