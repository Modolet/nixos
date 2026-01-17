{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      winPackages = with pkgs; [
        clang
        lld
        llvm
        xwin
        cmake
        ninja
        pkg-config
      ];
      winSysroot = pkgs.stdenvNoCC.mkDerivation {
        pname = "xwin-sysroot";
        inherit (pkgs.xwin) version;
        nativeBuildInputs = [ pkgs.xwin ];
        dontUnpack = true;
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = pkgs.lib.fakeSha256;
        installPhase = ''
          export XWIN_ACCEPT_LICENSE=1
          export XWIN_CACHE_DIR="$TMPDIR/xwin-cache"
          mkdir -p "$XWIN_CACHE_DIR"

          xwin --accept-license \
            --cache-dir "$XWIN_CACHE_DIR" \
            --arch x86 --arch x86_64 \
            --variant desktop \
            --include-debug-runtime \
            download

          xwin --accept-license \
            --cache-dir "$XWIN_CACHE_DIR" \
            --arch x86 --arch x86_64 \
            --variant desktop \
            splat \
            --output "$out" \
            --use-winsysroot-style \
            --include-debug-libs
        '';
      };
    in
    {
      packages.win-clang-sysroot = winSysroot;
      devShells.win-clang = pkgs.mkShell {
        packages = winPackages ++ [ winSysroot ];
        XWIN_SYSROOT = "${winSysroot}";
        CC = "clang-cl";
        CXX = "clang-cl";
        LD = "lld-link";
        AR = "llvm-lib";
        RC = "llvm-rc";
      };
    };
}
