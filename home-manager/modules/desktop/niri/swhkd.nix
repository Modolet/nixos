{ user, config, ... }:
let
  niriAction = key: action: {
    inherit key;
    command = "niri msg action ${action}";
  };
in
{
  xdg.configFile."niri/swhkd/niri.swhkdrc".text = config.lib.swhkd.mkSwhkdrc {
    includes = [
      "/home/${user}/.config/swhkd/basic.swhkdrc"
      "/home/${user}/.config/swhkd/tofi.swhkdrc"
    ];
    keyBindings = [
      {
        key = "super + shift + w";
        command =
          if config.desktopShell == "caelestia" then
            "/home/${user}/scripts/change-wal-niri && caelestia wallpaper -f ~/Pictures/Wallpapers/generated/$(cat ~/Pictures/Wallpapers/${config.lib.monitors.mainMonitorName}-file) && caelestia scheme set -n dynamic -m dark"
          else
            "/home/${user}/scripts/change-wal-niri";
      }
      (niriAction "super + q" "close-window")
      (niriAction "super + t" "toggle-column-tabbed-display")
      (niriAction "super + {left, down, up, right}" "focus-column-{left, down, up, right}")
      (niriAction "super + {h, l}" "focus-column-or-monitor-{left, right}")
      (niriAction "super + {j, k}" "focus-window-or-workspace-{down, up}")
      (niriAction "super + shift + h" "move-column-left-or-to-monitor-left")
      (niriAction "super + shift + l" "move-column-right-or-to-monitor-right")
      (niriAction "super + shift + j" "move-window-down-or-to-workspace-down")
      (niriAction "super + shift + k" "move-window-up-or-to-workspace-up")
      (niriAction "super + ctrl + {left, down, up, right}" "focus-monitor-{left, down, up, right}")
      (niriAction "super + ctrl + {h, j, k, l}" "focus-monitor-{left, down, up, right}")
      (niriAction "super + shift + ctrl + {left, down, up, right}" "move-window-to-monitor-{left, down, up, right}")
      (niriAction "super + shift + ctrl + {h, j, k, l}" "move-window-to-monitor-{left, down, up, right}")
      (niriAction "super + shift + space" "toggle-window-floating")
      (niriAction "super + space" "switch-focus-between-floating-and-tiling")
      (niriAction "super + {_, shift +} {1-9}" "{focus\\-workspace, move\\-window\\-to\\-workspace} {1-9}")
      (niriAction "super + comma" "consume-window-into-column")
      (niriAction "super + period" "expel-window-from-column")
      (niriAction "super + r" "switch-preset-column-width")
      (niriAction "super + f" "maximize-column")
      (niriAction "super + shift + f" "fullscreen-window")
      (niriAction "super + ctrl + f" "toggle-windowed-fullscreen")
      (niriAction "super + c" "center-column")
      (niriAction "super + {_, shift +} {minus, equal}" "set-{column\\-width, window\\-height} \"{\\-, +}10%\"")
      (niriAction "super + alt + {h, j, k, l}" "move-floating-window -{x \\-10, y +10, y \\-10, x +10}")
      (niriAction "{ctrl +, alt +} print" "screenshot-{screen, window}")
      (niriAction "print" "screenshot")
      (niriAction "super + w" "toggle-overview")
      (niriAction "super + alt + m" "set-dynamic-cast-monitor")
      (niriAction "super + alt + w" "set-dynamic-cast-window")
      (niriAction "super + alt + n" "clear-dynamic-cast-target")
      {
        key = "super + ctrl + c";
        command = "niri msg pick-color | grep Hex | sd 'Hex: ' '' | sd '\\n' '' | wl-copy";
      }
    ];
  };

  # 基础快捷键配置
  xdg.configFile."swhkd/basic.swhkdrc".text = config.lib.swhkd.mkSwhkdrc {
    keyBindings = [
      {
        key = "super + shift + r";
        command = "pkill -HUP swhkd";
      }
      {
        key = "super + alt + c";
        command = "wl-color-picker";
      }
      {
        key = "super + b";
        command =
          {
            waybar = "pkill -USR1 .waybar-wrapped";
            dms = "dms ipc call bar toggle";
            caelestia = "echo pass";
            noctalia-shell = "noctalia-shell ipc call bar toggle";
          }
          .${config.desktopShell};
      }
      {
        key = "XF86AudioMute";
        command = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      }
      {
        key = "XF86AudioMicMute";
        command = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      }
      {
        key = "XF86AudioRaiseVolume";
        command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
      }
      {
        key = "XF86AudioLowerVolume";
        command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
      }
      {
        key = "super + shift + s";
        command =
          with config.lib.stylix.colors.withHashtag;
          ''wshowkeys -a bottom -a right -F "Comic Code 30" -b "${base00}aa" -f "${base0E}ee" -s "${base0F}ee" -t 1'';
      }
      {
        key = "super + e";
        command = "hexecute";
      }
    ];
  };

  # tofi 快捷键配置
  xdg.configFile."swhkd/tofi.swhkdrc".text = config.lib.swhkd.mkSwhkdrc {
    keyBindings = [
      {
        key = "super + x";
        command = "/home/${user}/scripts/tofi/powermenu";
      }
      {
        key = "super + shift + p";
        command = "sh -c $(tofi-drun)";
      }
    ];
  };
}