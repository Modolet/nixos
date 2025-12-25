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

      current_profile=""
      if [ -e "$profile_dir/home-manager" ]; then
        current_profile="$profile_dir/home-manager"
      elif [ -e "$hm_state_dir/gcroots/current-home" ]; then
        current_profile="$hm_state_dir/gcroots/current-home"
      elif [ -e "$global_profile" ]; then
        current_profile="$global_profile"
      fi

      specialisations_dir=""
      base_dir=""
      if [ -n "$current_profile" ]; then
        current_profile="$(readlink -f "$current_profile")"
        matches="$(find /nix/store/*home-manager-generation/ -lname "$current_profile" -printf '%h\n' 2>/dev/null || true)"
        if [ -n "$matches" ]; then
          base_dir="$(printf '%s\n' "$matches" | sort -u | xargs ls -dt 2>/dev/null | head -n 1 || true)"
          if [ -n "$base_dir" ] && [ -d "$base_dir/specialisation" ]; then
            specialisations_dir="$base_dir/specialisation"
          fi
        elif [ -d "$current_profile/specialisation" ]; then
          specialisations_dir="$current_profile/specialisation"
          base_dir="$current_profile"
        else
          base_dir="$current_profile"
        fi
      fi

      target=""
      if [ "$theme" = "default" ]; then
        if [ -n "$base_dir" ]; then
          target="$base_dir/activate"
        fi
      else
        if [ -n "$base_dir" ] && [ -x "$base_dir/specialisation/$theme/activate" ]; then
          target="$base_dir/specialisation/$theme/activate"
        fi
      fi

      if [ -z "$target" ] && [ "$theme" != "default" ]; then
        fallback="$(find /nix/store/*home-manager-generation/specialisation -maxdepth 1 -type l -name "$theme" 2>/dev/null | head -n 1 || true)"
        if [ -n "$fallback" ]; then
          target="$fallback/activate"
        fi
      fi

      if [ -z "$target" ]; then
        echo "specialisation not found: $theme" >&2
        exit 1
      fi

      exec "$target" --driver-version 1
    '')
  ];

  qt = {
    enable = true;
  };

}
