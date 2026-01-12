{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.wallpaper;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    optionalString
    concatStringsSep
    ;

  wallpaperDir = cfg.wallpaperDir;
  wallpaperNames =
    if cfg.wallpaperList != [ ] then
      cfg.wallpaperList
    else if (cfg.wallpaperDir == pkgs.wallpapers && pkgs.wallpapers ? wallpaperNames) then
      pkgs.wallpapers.wallpaperNames
    else
      let
        dirEntries = builtins.readDir wallpaperDir;
        dirNames = builtins.attrNames dirEntries;
        visible =
          builtins.filter (
            name:
            let
              kind = dirEntries.${name};
            in
            kind == "regular" || kind == "symlink"
          ) dirNames;
      in
      visible;

  wallpapers = map (name: {
    inherit name;
    path = "${wallpaperDir}/${name}";
  }) wallpaperNames;

  defaultWallpaper =
    if cfg.defaultWallpaper != null then
      cfg.defaultWallpaper
    else if wallpaperNames != [ ] then
      builtins.head wallpaperNames
    else
      null;

  stylixPalette = with config.lib.stylix.colors.withHashtag; {
    base00 = base00;
    base01 = base01;
    base02 = base02;
    base03 = base03;
    base04 = base04;
    base05 = base05;
    base06 = base06;
    base07 = base07;
    base08 = base08;
    base09 = base09;
    base0A = base0A;
    base0B = base0B;
    base0C = base0C;
    base0D = base0D;
    base0E = base0E;
    base0F = base0F;
  };

  paletteFile = "wallpaper/palette.json";
  configFile = "wallpaper/config.json";
  monetMapPath = "${cfg.stateDir}/monet-map.json";

  sanitizeName =
    name:
    lib.toLower (lib.replaceStrings [ " " "/" "." ] [ "-" "-" "-" ] name);

  monetSpecialisationName = name: "${cfg.monet.specialisationPrefix}${sanitizeName name}";

  pythonRecolor = pkgs.python3.withPackages (ps: with ps; [ pillow tqdm ]);
  recolorScript = ../../tools/icon-recolor.py;

  mkMonetScheme =
    name: image:
    let
      contrastArg = optionalString (cfg.monet.contrast != null) "--contrast ${toString cfg.monet.contrast}";
      resizeArg = optionalString (cfg.monet.resizeFilter != null) "--resize-filter ${cfg.monet.resizeFilter}";
    in
    pkgs.runCommand "monet-${sanitizeName name}.yaml" {
      nativeBuildInputs = [ pkgs.matugen pkgs.python3 ];
    } ''
      set -euo pipefail

      matugen image ${lib.escapeShellArg image} \
        --mode ${cfg.monet.mode} \
        --type ${cfg.monet.scheme} \
        --json hex \
        --quiet \
        ${contrastArg} \
        ${resizeArg} \
        > colors.json

      MONET_MODE=${lib.escapeShellArg cfg.monet.mode} \
        MONET_NAME=${lib.escapeShellArg name} \
        OUT_PATH="$out" \
        ${pkgs.python3}/bin/python - <<'PY'
      import json
      import os

      with open("colors.json", "r", encoding="utf-8") as handle:
          data = json.load(handle)

      mode = os.environ["MONET_MODE"]
      name = os.environ["MONET_NAME"]
      out_path = os.environ["OUT_PATH"]
      colors = data["colors"]

      def pick(key):
          return colors[key][mode]

      palette = {
          "base00": pick("background"),
          "base01": pick("surface_container_low"),
          "base02": pick("surface_container"),
          "base03": pick("surface_container_high"),
          "base04": pick("outline"),
          "base05": pick("on_surface"),
          "base06": pick("on_surface_variant"),
          "base07": pick("on_background"),
          "base08": pick("error"),
          "base09": pick("primary"),
          "base0A": pick("secondary"),
          "base0B": pick("tertiary"),
          "base0C": pick("primary_container"),
          "base0D": pick("secondary_container"),
          "base0E": pick("tertiary_container"),
          "base0F": pick("inverse_primary"),
      }

      lines = [
          'system: "base16"',
          f'name: "Monet {name}"',
          'author: "matugen"',
          f'variant: "{mode}"',
          "palette:",
      ]
      for key in [
          "base00",
          "base01",
          "base02",
          "base03",
          "base04",
          "base05",
          "base06",
          "base07",
          "base08",
          "base09",
          "base0A",
          "base0B",
          "base0C",
          "base0D",
          "base0E",
          "base0F",
      ]:
          lines.append(f'  {key}: "{palette[key]}"')

      with open(out_path, "w", encoding="utf-8") as handle:
          handle.write("\n".join(lines) + "\n")
      PY
    '';

  monetEntries =
    if cfg.monet.enable then
      map (wp: {
        inherit (wp) name;
        theme = monetSpecialisationName wp.name;
        scheme = mkMonetScheme wp.name wp.path;
      }) wallpapers
    else
      [ ];

  monetMap = lib.listToAttrs (map (entry: {
    name = entry.name;
    value = {
      theme = entry.theme;
      scheme = toString entry.scheme;
    };
  }) monetEntries);

  monetSpecialisations = lib.listToAttrs (map (entry: {
    name = entry.theme;
    value.configuration = {
      stylix.base16Scheme = toString entry.scheme;
      stylix.polarity = cfg.monet.mode;
    };
  }) monetEntries);

  wallpaperConfig = {
    defaultMode = cfg.mode;
    defaultWallpaper = defaultWallpaper;
    wallpapers = wallpapers;
    paletteFile = "${config.xdg.configHome}/${paletteFile}";
    themeSpecFile = cfg.themeSpecFile;
    stateDir = cfg.stateDir;
    cacheDir = cfg.cacheDir;
    swww = cfg.swww;
    recolor = cfg.recolor;
    monet = {
      enable = cfg.monet.enable;
      mapFile = monetMapPath;
      prefix = cfg.monet.specialisationPrefix;
    };
  };

  wallpaperScript = pkgs.writeShellApplication {
    name = "wallpaper";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gawk
      pkgs.jq
      pkgs.swww
      pythonRecolor
    ];
    text = ''
      set -euo pipefail

      config_file="''${XDG_CONFIG_HOME:-$HOME/.config}/${configFile}"
      state_dir="$(jq -r '.stateDir // empty' "$config_file")"
      if [ -z "$state_dir" ] || [ "$state_dir" = "null" ]; then
        state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/wallpaper"
      fi
      state_file="$state_dir/state.json"
      cache_root="$(jq -r '.cacheDir // empty' "$config_file")"
      if [ -z "$cache_root" ] || [ "$cache_root" = "null" ]; then
        cache_root="''${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper"
      fi

      ensure_state() {
        mkdir -p "$state_dir"
        if [ ! -f "$state_file" ]; then
          local default_mode default_wallpaper
          default_mode="$(jq -r '.defaultMode' "$config_file")"
          default_wallpaper="$(jq -r '.defaultWallpaper' "$config_file")"
          jq -n --arg mode "$default_mode" --arg wallpaper "$default_wallpaper" \
            '{mode: $mode, wallpaper: $wallpaper}' >"$state_file"
        fi
      }

      read_state() {
        ensure_state
        mode="$(jq -r '.mode // empty' "$state_file")"
        wallpaper="$(jq -r '.wallpaper // empty' "$state_file")"
        pre_monet_theme="$(jq -r '.preMonetTheme // empty' "$state_file")"
      }

      write_state() {
        mkdir -p "$state_dir"
        jq -n \
          --arg mode "$mode" \
          --arg wallpaper "$wallpaper" \
          --arg preMonetTheme "$pre_monet_theme" \
          '{
            mode: $mode,
            wallpaper: $wallpaper
          }
          + if ($preMonetTheme | length) > 0 then { preMonetTheme: $preMonetTheme } else {} end' \
          >"$state_file"
      }

      wallpaper_names() {
        jq -r '.wallpapers[].name' "$config_file"
      }

      wallpaper_path() {
        jq -r --arg name "$1" '.wallpapers[] | select(.name == $name) | .path' "$config_file"
      }

      monet_theme() {
        local map_file
        map_file="$(jq -r '.monet.mapFile' "$config_file")"
        if [ ! -f "$map_file" ]; then
          return 1
        fi
        jq -r --arg name "$1" '.[$name].theme // empty' "$map_file"
      }

      current_theme() {
        local theme_spec
        theme_spec="$(jq -r '.themeSpecFile' "$config_file")"
        if [ -f "$theme_spec" ]; then
          tr -d '[:space:]' <"$theme_spec"
        fi
      }

      ensure_swww() {
        if ! swww query >/dev/null 2>&1; then
          if command -v systemctl >/dev/null 2>&1; then
            systemctl --user start swww-daemon.service >/dev/null 2>&1 || true
          fi
          sleep 0.2
        fi
      }

      build_swww_args() {
        local ttype tfps tduration tbezier tstep
        ttype="$(jq -r '.swww.transition.type // empty' "$config_file")"
        tfps="$(jq -r '.swww.transition.fps // empty' "$config_file")"
        tduration="$(jq -r '.swww.transition.duration // empty' "$config_file")"
        tbezier="$(jq -r '.swww.transition.bezier // empty' "$config_file")"
        tstep="$(jq -r '.swww.transition.step // empty' "$config_file")"

        swww_args=()
        if [ -n "$ttype" ] && [ "$ttype" != "null" ]; then
          swww_args+=(--transition-type "$ttype")
        fi
        if [ -n "$tduration" ] && [ "$tduration" != "null" ]; then
          swww_args+=(--transition-duration "$tduration")
        fi
        if [ -n "$tfps" ] && [ "$tfps" != "null" ]; then
          swww_args+=(--transition-fps "$tfps")
        fi
        if [ -n "$tbezier" ] && [ "$tbezier" != "null" ]; then
          swww_args+=(--transition-bezier "$tbezier")
        fi
        if [ -n "$tstep" ] && [ "$tstep" != "null" ]; then
          swww_args+=(--transition-step "$tstep")
        fi
      }

      recolor_wallpaper() {
        local source="$1"
        local name="$2"
        local palette_file palette palette_hash cache_dir cached_file smooth_flag smooth_arg

        palette_file="$(jq -r '.paletteFile' "$config_file")"
        if [ ! -f "$palette_file" ]; then
          echo "palette file missing: $palette_file" >&2
          exit 1
        fi

        palette="$(jq -r '[.base00,.base01,.base02,.base03,.base04,.base05,.base06,.base07,.base08,.base09,.base0A,.base0B,.base0C,.base0D,.base0E,.base0F] | join(\",\")' "$palette_file")"
        palette_hash="$(sha256sum "$palette_file" | awk '{print $1}')"
        smooth_flag="$(jq -r '.recolor.smooth // true' "$config_file")"
        smooth_arg=""
        if [ "$smooth_flag" = "false" ]; then
          smooth_arg="--no-smooth"
        fi

        cache_dir="$cache_root/recolor/$palette_hash/$name"
        cached_file="$cache_dir/$name"

        if [ ! -f "$cached_file" ]; then
          mkdir -p "$cache_dir"
          cp "$source" "$cached_file"
          ${pythonRecolor}/bin/python ${lib.escapeShellArg recolorScript} $smooth_arg --palette "$palette" --src "$cache_dir" >/dev/null
        fi

        printf '%s\n' "$cached_file"
      }

      apply_wallpaper() {
        read_state

        local state_changed=0
        if [ -z "$mode" ]; then
          mode="$(jq -r '.defaultMode' "$config_file")"
          state_changed=1
        fi
        if [ -z "$wallpaper" ]; then
          wallpaper="$(jq -r '.defaultWallpaper' "$config_file")"
          state_changed=1
        fi

        local wallpaper_path_value
        wallpaper_path_value="$(wallpaper_path "$wallpaper")"
        if [ -z "$wallpaper_path_value" ] || [ "$wallpaper_path_value" = "null" ]; then
          wallpaper="$(jq -r '.defaultWallpaper' "$config_file")"
          wallpaper_path_value="$(wallpaper_path "$wallpaper")"
          state_changed=1
        fi

        if [ "$state_changed" -eq 1 ]; then
          write_state
        fi

        if [ -z "$wallpaper_path_value" ] || [ "$wallpaper_path_value" = "null" ]; then
          echo "no wallpaper available" >&2
          exit 1
        fi

        local target_path="$wallpaper_path_value"
        if [ "$mode" = "recolor" ]; then
          target_path="$(recolor_wallpaper "$wallpaper_path_value" "$wallpaper")"
        fi

        ensure_swww
        build_swww_args
        swww img "''${swww_args[@]}" "$target_path"

        local theme_spec desired_theme
        theme_spec="$(current_theme)"
        if [ "$mode" = "monet" ]; then
          desired_theme="$(monet_theme "$wallpaper")"
          if [ -n "$desired_theme" ] && [ "$theme_spec" != "$desired_theme" ]; then
            if command -v theme-switch >/dev/null 2>&1; then
              theme-switch "$desired_theme" || true
            fi
          fi
        else
          if [ -n "$pre_monet_theme" ] && [ -n "$theme_spec" ]; then
            local prefix
            prefix="$(jq -r '.monet.prefix' "$config_file")"
            if [ -n "$prefix" ] && [ "$prefix" != "null" ] && [ "''${theme_spec#"$prefix"}" != "$theme_spec" ]; then
              if command -v theme-switch >/dev/null 2>&1; then
                theme-switch "$pre_monet_theme" || true
              fi
            fi
          fi
        fi
      }

      next_prev_wallpaper() {
        local direction="$1"
        local names index target
        mapfile -t names < <(wallpaper_names)
        if [ "''${#names[@]}" -eq 0 ]; then
          echo "no wallpapers configured" >&2
          exit 1
        fi
        read_state
        index=0
        for i in "''${!names[@]}"; do
          if [ "''${names[$i]}" = "$wallpaper" ]; then
            index="$i"
            break
          fi
        done
        if [ "$direction" = "next" ]; then
          target=$(( (index + 1) % ''${#names[@]} ))
        else
          target=$(( (index - 1 + ''${#names[@]}) % ''${#names[@]} ))
        fi
        wallpaper="''${names[$target]}"
        write_state
        apply_wallpaper
      }

      set_mode() {
        local new_mode="$1"
        read_state
        if [ "$mode" = "monet" ] && [ "$new_mode" != "monet" ]; then
          :
        elif [ "$mode" != "monet" ] && [ "$new_mode" = "monet" ]; then
          pre_monet_theme="$(current_theme)"
        fi
        mode="$new_mode"
        write_state
        apply_wallpaper
      }

      cmd="''${1:-}"
      case "$cmd" in
        list)
          read_state
          while IFS= read -r name; do
            if [ "$name" = "$wallpaper" ]; then
              printf '* %s\n' "$name"
            else
              printf '  %s\n' "$name"
            fi
          done < <(wallpaper_names)
          ;;
        current)
          read_state
          path="$(wallpaper_path "$wallpaper")"
          printf 'mode: %s\nwallpaper: %s\npath: %s\n' "$mode" "$wallpaper" "$path"
          ;;
        set)
          if [ $# -lt 2 ]; then
            echo "usage: wallpaper set <name>" >&2
            exit 1
          fi
          read_state
          if [ -z "$(wallpaper_path "$2")" ] || [ "$(wallpaper_path "$2")" = "null" ]; then
            echo "wallpaper not found: $2" >&2
            exit 1
          fi
          wallpaper="$2"
          write_state
          apply_wallpaper
          ;;
        next)
          next_prev_wallpaper next
          ;;
        prev)
          next_prev_wallpaper prev
          ;;
        mode)
          if [ $# -lt 2 ]; then
            read_state
            printf '%s\n' "$mode"
            exit 0
          fi
          case "$2" in
            plain|recolor|monet)
              set_mode "$2"
              ;;
            *)
              echo "unknown mode: $2" >&2
              exit 1
              ;;
          esac
          ;;
        apply)
          apply_wallpaper
          ;;
        *)
          echo "usage: wallpaper <list|current|set|next|prev|mode|apply>" >&2
          exit 1
          ;;
      esac
    '';
  };
in
{
  options.modules.wallpaper = {
    enable = mkEnableOption "swww wallpaper manager";

    mode = mkOption {
      type = types.enum [ "plain" "recolor" "monet" ];
      default = "plain";
      description = "Default wallpaper mode.";
    };

    wallpaperDir = mkOption {
      type = types.path;
      default = pkgs.wallpapers;
      description = "Wallpaper directory managed by Nix.";
    };

    wallpaperList = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Wallpaper names to expose (empty = all in wallpaperDir).";
    };

    defaultWallpaper = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Default wallpaper name.";
    };

    themeSpecFile = mkOption {
      type = types.str;
      default = "${config.xdg.stateHome}/theme-switch/spec";
      description = "Path to the current theme spec file.";
    };

    stateDir = mkOption {
      type = types.str;
      default = "${config.xdg.stateHome}/wallpaper";
      description = "Wallpaper state directory.";
    };

    cacheDir = mkOption {
      type = types.str;
      default = "${config.xdg.cacheHome}/wallpaper";
      description = "Wallpaper cache directory.";
    };

    swww = {
      transition = {
        type = mkOption {
          type = types.str;
          default = "wipe";
          description = "swww transition type.";
        };
        duration = mkOption {
          type = types.float;
          default = 1.0;
          description = "swww transition duration in seconds.";
        };
        fps = mkOption {
          type = types.int;
          default = 60;
          description = "swww transition fps.";
        };
        bezier = mkOption {
          type = types.nullOr types.str;
          default = "0.4,0.0,0.2,1.0";
          description = "swww transition bezier (null to disable).";
        };
        step = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = "swww transition step (null to disable).";
        };
      };
    };

    recolor = {
      smooth = mkOption {
        type = types.bool;
        default = true;
        description = "Enable recolor smoothing.";
      };
    };

    monet = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Monet theme generation.";
      };
      scheme = mkOption {
        type = types.enum [
          "scheme-content"
          "scheme-expressive"
          "scheme-fidelity"
          "scheme-fruit-salad"
          "scheme-monochrome"
          "scheme-neutral"
          "scheme-rainbow"
          "scheme-tonal-spot"
          "scheme-vibrant"
        ];
        default = "scheme-tonal-spot";
        description = "Material You scheme type for Monet generation.";
      };
      mode = mkOption {
        type = types.enum [ "dark" "light" ];
        default = "dark";
        description = "Monet palette mode.";
      };
      contrast = mkOption {
        type = types.nullOr types.float;
        default = null;
        description = "Matugen contrast (-1 to 1).";
      };
      resizeFilter = mkOption {
        type = types.nullOr (types.enum [ "nearest" "triangle" "catmull-rom" "gaussian" "lanczos3" ]);
        default = "lanczos3";
        description = "Matugen resize filter.";
      };
      specialisationPrefix = mkOption {
        type = types.str;
        default = "monet-";
        description = "Prefix for monet specialisations.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = wallpaperNames != [ ];
        message = "modules.wallpaper.wallpaperDir has no wallpaper files.";
      }
      {
        assertion = defaultWallpaper == null || lib.elem defaultWallpaper wallpaperNames;
        message = "modules.wallpaper.defaultWallpaper must exist in wallpaper list.";
      }
    ];

    xdg.configFile.${paletteFile}.text = builtins.toJSON stylixPalette;

    xdg.configFile.${configFile}.text = builtins.toJSON wallpaperConfig;

    home.packages = [
      wallpaperScript
    ];

    systemd.user.services.swww-daemon = {
      Unit = {
        Description = "swww daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    systemd.user.services.wallpaper-apply = {
      Unit = {
        Description = "Apply wallpaper state";
        PartOf = [ "graphical-session.target" ];
        After = [
          "graphical-session.target"
          "swww-daemon.service"
          "theme-switch-restore.service"
        ];
        Wants = [ "swww-daemon.service" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${wallpaperScript}/bin/wallpaper apply";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    home.activation.wallpaperMonetMap = lib.hm.dag.entryAfter [ "writeBoundary" ] (lib.optionalString cfg.monet.enable ''
      install -d ${lib.escapeShellArg cfg.stateDir}
      cat > ${lib.escapeShellArg monetMapPath} <<'EOF'
      ${builtins.toJSON monetMap}
      EOF
    '');

    home.activation.wallpaperApply = lib.hm.dag.entryAfter [ "writeBoundary" "wallpaperMonetMap" ] ''
      if command -v systemctl >/dev/null 2>&1; then
        systemctl --user start wallpaper-apply.service >/dev/null 2>&1 || true
      else
        ${wallpaperScript}/bin/wallpaper apply >/dev/null 2>&1 || true
      fi
    '';

    specialisation = mkIf cfg.monet.enable monetSpecialisations;
  };
}
