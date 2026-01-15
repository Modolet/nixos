{
  pkgs,
  lib,
  config,
  ...
}:
let
  themeSpecFile = "${config.xdg.stateHome}/theme-switch/spec";
  # Keep HM specialisation data first so icon theme follows theme-switch.
  hmDataDir = "${config.xdg.stateHome}/home-manager/gcroots/current-home/home-path/share";
  xdgDataDirs = lib.concatStringsSep ":" [
    hmDataDir
    "${config.xdg.dataHome}/flatpak/exports/share"
    "/var/lib/flatpak/exports/share"
    "${config.home.homeDirectory}/.nix-profile/share"
    "/nix/profile/share"
    "${config.xdg.stateHome}/nix/profile/share"
    "/etc/profiles/per-user/${config.home.username}/share"
    "/nix/var/nix/profiles/default/share"
    "/run/current-system/sw/share"
  ];
  themeSwitchRestore = pkgs.writeShellApplication {
    name = "theme-switch-restore";
    text = ''
      set -euo pipefail
      dms restart
      dms restart

      spec_file=${lib.escapeShellArg themeSpecFile}
      if [ ! -f "$spec_file" ]; then
        exit 0
      fi

      saved_theme="$(tr -d '[:space:]' < "$spec_file" || true)"
      if [ -z "$saved_theme" ]; then
        exit 0
      fi

      if ! command -v theme-switch >/dev/null 2>&1; then
        exit 0
      fi

      if ! theme-switch "$saved_theme"; then
        printf 'theme-switch-restore: failed to load saved theme "%s", falling back to default\n' "$saved_theme" >&2
        theme-switch default || true
      fi
    '';
  };
in
{
  imports = [
    ./niri
    ./pkgs.nix
    ./browser/firefox.nix
    ./desktopShell.nix
    ./autoStart.nix
    ./terminal/kitty.nix
    ./dms.nix
    ./fcitx5.nix
    ./wallpaper.nix
  ];

  home.packages = with pkgs; [
    xwayland-satellite
    swww
    swaybg
    themeSwitchRestore
    (writeShellScriptBin "theme-switch" ''
      set -euo pipefail

      default_theme="default"
      show_help=0
      if [ $# -eq 0 ]; then
        theme="$default_theme"
      else
        if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
          show_help=1
          theme="$default_theme"
        else
          theme="$1"
        fi
      fi

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

      base_dir=""
      hm_service="home-manager-$USER.service"
      hm_execstart="$(systemctl show -p ExecStart "$hm_service" --no-pager 2>/dev/null || true)"
      if [ -n "$hm_execstart" ]; then
        base_dir="$(printf '%s\n' "$hm_execstart" | grep -oE '/nix/store/[^ ]+-home-manager-generation' | tail -n 1 || true)"
        if [ -n "$base_dir" ] && [ ! -d "$base_dir" ]; then
          base_dir=""
        fi
      fi

      if [ -z "$base_dir" ]; then
        if [ -n "$resolved_current" ] && [ -d "$resolved_current/specialisation" ]; then
          base_dir="$resolved_current"
        elif [ -n "$resolved_current" ]; then
          matches="$(find /nix/store/*home-manager-generation/specialisation -maxdepth 1 -type l -lname "$resolved_current" -printf '%h\n' 2>/dev/null || true)"
          if [ -n "$matches" ]; then
            base_dir="$(printf '%s\n' "$matches" | sed 's#/specialisation$##' | sort -u | xargs ls -dt 2>/dev/null | head -n 1 || true)"
          fi
        fi
      fi

      if [ -z "$base_dir" ]; then
        specialisations_dir="$(ls -dt /nix/store/*home-manager-generation/specialisation 2>/dev/null | head -n 1 || true)"
        if [ -n "$specialisations_dir" ]; then
          base_dir="$(dirname "$specialisations_dir")"
        fi
      fi

      if [ -z "$base_dir" ] || [ ! -x "$base_dir/activate" ]; then
        echo "theme-switch: could not locate a usable home-manager generation" >&2
        exit 1
      fi

      if [ "$show_help" -eq 1 ]; then
        echo "usage: theme-switch [default|<specialisation>]"
        if [ -d "$base_dir/specialisation" ]; then
          echo "available:"
          ls -1 "$base_dir/specialisation" 2>/dev/null || true
        fi
        exit 0
      fi

      if [ "$theme" != "default" ] && [ ! -x "$base_dir/specialisation/$theme/activate" ]; then
        echo "unknown theme: $theme" >&2
        exit 1
      fi

      spec_file=${lib.escapeShellArg themeSpecFile}
      spec_dir="$(dirname "$spec_file")"
      mkdir -p "$spec_dir"
      printf '%s\n' "$theme" > "$spec_file"

      if [ "$theme" = "default" ]; then
        exec "$base_dir/activate"
      fi

      exec "$base_dir/specialisation/$theme/activate" --driver-version 1
    '')
  ];

  home.sessionVariables = {
    XDG_DATA_DIRS = xdgDataDirs;
  };

  systemd.user.services.theme-switch-restore = {
    Unit = {
      Description = "Restore theme-switch specialisation on login";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${themeSwitchRestore}/bin/theme-switch-restore";
      ExecStartPost = "${pkgs.systemd}/bin/systemctl --user start --no-block wallpaper-apply.service";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  qt = {
    enable = true;
  };

}
