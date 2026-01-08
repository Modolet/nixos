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

      resolved_current=""
      if [ -n "$current_profile" ]; then
        resolved_current="$(readlink -f "$current_profile" 2>/dev/null || true)"
      fi

      specialisations_dir=""
      base_dir=""
      pick_latest_specialisations() {
        if [ ! -d "$profile_dir" ]; then
          return 1
        fi
        for num in $(ls "$profile_dir"/home-manager-*-link 2>/dev/null | sed 's#.*/home-manager-##; s#-link##' | sort -nr || true); do
          candidate="$profile_dir/home-manager-$num-link"
          target_link="$(readlink -f "$candidate" 2>/dev/null || true)"
          if [ -n "$target_link" ] && [ -d "$target_link/specialisation" ]; then
            if [ "$theme" = "default" ] || [ -x "$target_link/specialisation/$theme/activate" ]; then
              base_dir="$target_link"
              specialisations_dir="$target_link/specialisation"
              return 0
            fi
          fi
        done
        return 1
      }

      if [ -n "$resolved_current" ] && [ -d "$resolved_current/specialisation" ]; then
        base_dir="$resolved_current"
        specialisations_dir="$resolved_current/specialisation"
      else
        pick_latest_specialisations || true
      fi

      if [ -z "$specialisations_dir" ]; then
        specialisations_dir="$(ls -dt /nix/store/*home-manager-generation/specialisation 2>/dev/null | head -n 1 || true)"
        if [ -n "$specialisations_dir" ]; then
          base_dir="$(dirname "$specialisations_dir")"
        fi
      fi

      target=""
      if [ "$theme" = "default" ]; then
        if [ -n "$base_dir" ]; then
          target="$base_dir/activate"
        elif [ -n "$current_profile" ]; then
          target="$current_profile/activate"
        fi
      else
        if [ -n "$specialisations_dir" ] && [ -x "$specialisations_dir/$theme/activate" ]; then
          target="$specialisations_dir/$theme/activate"
        fi
      fi

      if [ -n "$target" ] && [ "$theme" != "default" ]; then
        target_gen="${target%/activate}"
        if [ ! -e "$target_gen/home-files/.config/systemd/user/xremap.service" ]; then
          target=""
        fi
      fi

      if [ -z "$target" ] && [ "$theme" != "default" ]; then
        best_target=""
        best_score=-1
        while IFS= read -r link; do
          gen="$(readlink -f "$link" 2>/dev/null || true)"
          [ -n "$gen" ] || continue

          score=0
          [ -e "$gen/home-files/.config/systemd/user/xremap.service" ] && score=$((score + 10))
          [ -e "$gen/home-files/.config/niri/config.kdl" ] && score=$((score + 3))
          [ -e "$gen/home-files/.config/DankMaterialShell/stylix-colors.json" ] && score=$((score + 2))

          if [ "$score" -gt "$best_score" ]; then
            best_score="$score"
            best_target="$gen/activate"
          fi
        done < <(find /nix/store -maxdepth 3 -type l -path "*/specialisation/$theme" 2>/dev/null || true)

        if [ "$best_score" -ge 0 ] && [ -n "$best_target" ]; then
          target="$best_target"
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
