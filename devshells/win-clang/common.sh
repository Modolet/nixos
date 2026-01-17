win_join_by() {
  local IFS="$1"
  shift
  echo "$*"
}

win_find_cache_target() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/CMakeCache.txt" ]; then
      local target
      for key in CMAKE_C_COMPILER_TARGET CMAKE_CXX_COMPILER_TARGET; do
        target="$(awk -F= "/^${key}:/ {print \\$2; exit}" "$dir/CMakeCache.txt")"
        if [ -n "$target" ]; then
          echo "$target"
          return 0
        fi
      done
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

win_args_has_target() {
  local next_is_target=0
  for arg in "$@"; do
    if [ "$next_is_target" -eq 1 ]; then
      return 0
    fi
    case "$arg" in
      --target=*) return 0 ;;
      -target) next_is_target=1 ;;
    esac
  done
  return 1
}

win_find_args_target() {
  local next_is_target=0
  for arg in "$@"; do
    if [ "$next_is_target" -eq 1 ]; then
      echo "$arg"
      return 0
    fi
    case "$arg" in
      --target=*) echo "${arg#--target=}"; return 0 ;;
      -target) next_is_target=1 ;;
      /machine:*)
        case "${arg#/machine:}" in
          x86|X86) echo "i686-pc-windows-msvc"; return 0 ;;
          x64|X64|x86_64|X86_64|amd64|AMD64) echo "x86_64-pc-windows-msvc"; return 0 ;;
        esac
        ;;
      -m32) echo "i686-pc-windows-msvc"; return 0 ;;
      -m64) echo "x86_64-pc-windows-msvc"; return 0 ;;
    esac
  done
  return 1
}

win_resolve_target() {
  local target
  target="$(win_find_args_target "$@" || true)"
  if [ -n "$target" ]; then
    echo "$target"
    return 0
  fi

  target="$(win_find_cache_target || true)"
  if [ -n "$target" ]; then
    echo "$target"
    return 0
  fi

  echo "x86_64-pc-windows-msvc"
}

win_normalize_target() {
  case "$1" in
    i686|i686-pc-windows-msvc) echo "i686-pc-windows-msvc" ;;
    x86_64|x86_64-pc-windows-msvc) echo "x86_64-pc-windows-msvc" ;;
    *) echo "$1" ;;
  esac
}

win_setup_target() {
  WIN_TARGET="$(win_normalize_target "$(win_resolve_target "$@")")"
  export WIN_TARGET

  case "$WIN_TARGET" in
    i686*) WIN_SDK_ARCH="x86"; MACHINE_FLAG="/machine:x86" ;;
    x86_64*) WIN_SDK_ARCH="x86_64"; MACHINE_FLAG="/machine:x64" ;;
    *) echo "Unsupported WIN_TARGET: $WIN_TARGET" >&2; exit 1 ;;
  esac
  export WIN_SDK_ARCH MACHINE_FLAG
}

win_setup_paths() {
  XWIN_CRT_DIR="$XWIN_SYSROOT/VC/Tools/MSVC/$WIN_CRT_VERSION"
  XWIN_SDK_DIR="$XWIN_SYSROOT/WindowsKits/10"
  export XWIN_CRT_DIR XWIN_SDK_DIR
}

win_setup_include_lib() {
  local include_paths=(
    "$XWIN_CRT_DIR/include"
    "$XWIN_SDK_DIR/Include/$WIN_SDK_VERSION/shared"
    "$XWIN_SDK_DIR/Include/$WIN_SDK_VERSION/um"
    "$XWIN_SDK_DIR/Include/$WIN_SDK_VERSION/ucrt"
    "$XWIN_SDK_DIR/Include/$WIN_SDK_VERSION/winrt"
    "$XWIN_SDK_DIR/Include/$WIN_SDK_VERSION/cppwinrt"
  )
  local lib_paths=(
    "$XWIN_CRT_DIR/lib/$WIN_SDK_ARCH"
    "$XWIN_SDK_DIR/Lib/$WIN_SDK_VERSION/ucrt/$WIN_SDK_ARCH"
    "$XWIN_SDK_DIR/Lib/$WIN_SDK_VERSION/um/$WIN_SDK_ARCH"
  )
  INCLUDE="$(win_join_by ';' "${include_paths[@]}")${INCLUDE:+;$INCLUDE}"
  LIB="$(win_join_by ';' "${lib_paths[@]}")${LIB:+;$LIB}"
  export INCLUDE LIB
}

win_setup_env() {
  win_setup_target "$@"
  win_setup_paths
  win_setup_include_lib
}
