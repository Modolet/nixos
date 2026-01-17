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
    in
    {
      devShells.win-clang = pkgs.mkShell {
        packages = winPackages;
        shellHook = ''
          export XWIN_CACHE_DIR="''${XWIN_CACHE_DIR:-$HOME/.cache/xwin}"
          export XWIN_SYSROOT="''${XWIN_SYSROOT:-$HOME/.local/share/xwin/winsysroot}"
          export XWIN_ARCHS="''${XWIN_ARCHS:-x86 x86_64}"
          export XWIN_VARIANT="''${XWIN_VARIANT:-desktop}"

          export CC=clang-cl
          export CXX=clang-cl
          export LD=lld-link
          export AR=llvm-lib
          export RC=llvm-rc

          xwin-fetch() {
            xwin --accept-license \
              --cache-dir "$XWIN_CACHE_DIR" \
              --arch x86 --arch x86_64 \
              --variant "$XWIN_VARIANT" \
              --include-debug-runtime \
              download

            xwin --accept-license \
              --cache-dir "$XWIN_CACHE_DIR" \
              --arch x86 --arch x86_64 \
              --variant "$XWIN_VARIANT" \
              splat \
              --output "$XWIN_SYSROOT" \
              --use-winsysroot-style \
              --include-debug-libs
          }

          use-win32() {
            export WIN_TARGET="i686-pc-windows-msvc"
            export CFLAGS="--target=$WIN_TARGET --winsysroot=$XWIN_SYSROOT"
            export CXXFLAGS="$CFLAGS"
          }

          use-win64() {
            export WIN_TARGET="x86_64-pc-windows-msvc"
            export CFLAGS="--target=$WIN_TARGET --winsysroot=$XWIN_SYSROOT"
            export CXXFLAGS="$CFLAGS"
          }
        '';
      };
    };
}
