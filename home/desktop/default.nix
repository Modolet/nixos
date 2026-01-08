{ pkgs, lib, ... }:
{
  imports = [
    ./niri
    ./browser/firefox.nix
    ./desktopShell.nix
    ./autoStart.nix
    ./terminal/kitty.nix
    ./dms.nix
    ./fcitx5.nix
  ];

  home.packages = with pkgs; [
    xwayland-satellite
    swww
    swaybg
    (writeShellScriptBin "theme-switch" ''
      set -euo pipefail

      default_theme="default"
      if [ $# -eq 0 ]; then
        theme="$default_theme"
      else
        if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
          echo "usage: theme-switch [default|gruvbox|nord|tokyonight|onedark|catppuccin|dracula|solarized-dark|solarized-light]"
          exit 0
        fi
        theme="$1"
      fi
      case "$theme" in
        default|gruvbox|nord|tokyonight|onedark|catppuccin|dracula|solarized-dark|solarized-light)
          ;;
        *)
          echo "unknown theme: $theme" >&2
          exit 1
          ;;
      esac

      state_home="''${XDG_STATE_HOME:-$HOME/.local/state}"
      user_nix_state_dir="$state_home/nix"
      hm_state_dir="$state_home/home-manager"
      profile_dir="$user_nix_state_dir/profiles"
      global_profile="/nix/var/nix/profiles/per-user/$USER/home-manager"

      if [ ! -d "$profile_dir" ]; then
        echo "theme-switch: home-manager profile directory not found: $profile_dir" >&2
        exit 1
      fi

      latest_num="$(
        ls "$profile_dir"/home-manager-*-link 2>/dev/null \
          | sed 's#.*/home-manager-##; s#-link##' \
          | sort -nr \
          | head -n 1 \
          || true
      )"
      if [ -z "$latest_num" ]; then
        echo "theme-switch: no home-manager generations found under: $profile_dir" >&2
        exit 1
      fi

      base_dir="$(readlink -f "$profile_dir/home-manager-$latest_num-link" 2>/dev/null || true)"
      if [ -z "$base_dir" ] || [ ! -d "$base_dir" ]; then
        echo "theme-switch: failed to resolve latest generation: $profile_dir/home-manager-$latest_num-link" >&2
        exit 1
      fi

      if [ ! -d "$base_dir/specialisation" ]; then
        echo "theme-switch: latest generation has no specialisation dir: $base_dir" >&2
        echo "theme-switch: please rebuild/switch home-manager so the latest generation includes specialisations" >&2
        exit 1
      fi

      if [ "$theme" = "default" ]; then
        exec "$base_dir/activate"
      fi

      if [ ! -x "$base_dir/specialisation/$theme/activate" ]; then
        echo "specialisation not found in latest generation: $theme" >&2
        exit 1
      fi

      "$base_dir/activate"
      exec "$base_dir/specialisation/$theme/activate" --driver-version 1
    '')
  ];

  qt = {
    enable = true;
  };

}
