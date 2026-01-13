{
  config,
  pkgs,
  lib,
  ...
}:
let
  yamlFormat = pkgs.formats.yaml { };
  launchCmd = cmd: {
    launch = [
      "bash"
      "-lc"
      cmd
    ];
  };
  niriAction = action: launchCmd "niri msg action ${action}";
  barToggle =
    {
      waybar = "pkill -USR1 .waybar-wrapped";
      dms = "dms ipc call bar toggle";
      caelestia = "echo pass";
      noctalia-shell = "noctalia-shell ipc call bar toggle";
    }
    .${config.desktopShell or "dms"};
  colors = config.lib.stylix.colors.withHashtag;
  showKeysCmd =
    with colors;
    ''wshowkeys -a bottom -a right -F "Comic Code 30" -b "${base00}aa" -f "${base0E}ee" -s "${base0F}ee" -t 1'';
  workspaceRange = map builtins.toString (lib.range 1 9);
  workspaceFocus = lib.listToAttrs (
    map (n: {
      name = "Super-${n}";
      value = niriAction "focus-workspace ${n}";
    }) workspaceRange
  );
  workspaceMove = lib.listToAttrs (
    map (n: {
      name = "Super-Shift-${n}";
      value = niriAction "move-window-to-workspace ${n}";
    }) workspaceRange
  );
  commonRemap = {
    "Super-Shift-R" = launchCmd "systemctl --user restart xremap.service";
    "Super-Alt-C" = launchCmd "wl-color-picker";
    "Super-b" = launchCmd barToggle;
    "Mute" = launchCmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    "MicMute" = launchCmd "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
    "VolumeUp" = launchCmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
    "VolumeDown" = launchCmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
    "Super-Shift-s" = launchCmd showKeysCmd;
    "Super-e" = launchCmd "nautilus";
  };
  dmsRemap = {
    "Super-a" = launchCmd "dms ipc call spotlight toggle";
    "Super-Shift-e" = launchCmd "";
    "Ctrl-Alt-Left" = launchCmd "dms ipc call mpris previous";
    "Ctrl-Alt-Right" = launchCmd "dms ipc call mpris next";
    "Ctrl-Alt-p" = launchCmd "dms ipc call mpris playPause";
    "Super-Alt-l" = launchCmd "dms ipc call lock lock";
  };
  niriRemap = {
    "Super-q" = niriAction "close-window";
    "Alt-F4" = niriAction "close-window";
    "Super-Delete" = niriAction "quit";
    "Super-w" = niriAction "toggle-window-floating";
    "Super-g" = niriAction "toggle-column-tabbed-display";
    "Alt-Enter" = niriAction "fullscreen-window";
    "Super-Shift-f" = niriAction "toggle-windowed-fullscreen";
    "Super-o" = niriAction "consume-window-into-column";
    "Super-Shift-o" = niriAction "expel-window-from-column";
    "Super-space" = niriAction "switch-focus-between-floating-and-tiling";
    "Super-l" = launchCmd "swaylock";

    "Super-Tab" = niriAction "toggle-overview";

    "Super-Left" = niriAction "focus-column-left";
    "Super-Right" = niriAction "focus-column-right";
    "Super-Up" = niriAction "focus-column-up";
    "Super-Down" = niriAction "focus-column-down";
    "Super-h" = niriAction "focus-column-or-monitor-left";
    "Super-j" = niriAction "focus-window-or-workspace-down";
    "Super-k" = niriAction "focus-window-or-workspace-up";
    "Alt-Tab" = niriAction "focus-window-or-workspace-down";
    "Super-Ctrl-Left" = niriAction "focus-monitor-left";
    "Super-Ctrl-Right" = niriAction "focus-monitor-right";
    "Super-Ctrl-Up" = niriAction "focus-monitor-up";
    "Super-Ctrl-Down" = niriAction "focus-monitor-down";

    "Super-Shift-h" = niriAction "move-column-left-or-to-monitor-left";
    "Super-Shift-l" = niriAction "move-column-right-or-to-monitor-right";
    "Super-Shift-j" = niriAction "move-window-down-or-to-workspace-down";
    "Super-Shift-k" = niriAction "move-window-up-or-to-workspace-up";
    "Super-Shift-Ctrl-Left" = niriAction "move-window-to-monitor-left";
    "Super-Shift-Ctrl-Right" = niriAction "move-window-to-monitor-right";
    "Super-Shift-Ctrl-Up" = niriAction "move-window-to-monitor-up";
    "Super-Shift-Ctrl-Down" = niriAction "move-window-to-monitor-down";
    "Super-Shift-Left" = niriAction ''set-column-width "-10%"'';
    "Super-Shift-Right" = niriAction ''set-column-width "+10%"'';
    "Super-Shift-Up" = niriAction ''set-window-height "-10%"'';
    "Super-Shift-Down" = niriAction ''set-window-height "+10%"'';
    "Super-Alt-h" = niriAction "move-floating-window -x -30";
    "Super-Alt-j" = niriAction "move-floating-window -y +30";
    "Super-Alt-k" = niriAction "move-floating-window -y -30";
    "Super-Alt-l" = niriAction "move-floating-window -x +30";

    "Super-p" = niriAction "screenshot";
    "Super-Ctrl-p" = niriAction "screenshot-screen";
    "Super-Alt-p" = niriAction "screenshot-window";
    "Ctrl-Print" = niriAction "screenshot-screen";
    "Alt-Print" = niriAction "screenshot-window";
    "Print" = niriAction "screenshot";
    "Super-Shift-p" =
      launchCmd "niri msg pick-color | grep Hex | sd 'Hex: ' '' | sd '\\n' '' | wl-copy";

    "Super-t" = launchCmd "kitty";
    "Super-m" = launchCmd "kitty musicfox";
    "Super-e" = launchCmd "dolphin";
    "Super-c" = launchCmd "neovide";
    "Super-f" = launchCmd "firefox";
    "Ctrl-Shift-Esc" = launchCmd "kitty -e htop";
    "Super-v" = launchCmd "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
  }
  // workspaceFocus
  // workspaceMove
  // {
    "Super-0" = niriAction "focus-workspace 10";
    "Super-Shift-0" = niriAction "move-window-to-workspace 10";
  };
  xremapConfig = {
    keymap = [
      {
        name = "default";
        remap = commonRemap // niriRemap // dmsRemap;
      }
    ];
  };
  configPath = "${config.home.homeDirectory}/.config/xremap/config.yml";
in
{
  xdg.configFile."xremap/config.yml".source = yamlFormat.generate "xremap-config.yml" xremapConfig;

  systemd.user.services.xremap = {
    Unit = {
      Description = "xremap key mappings";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.xremap} --watch ${configPath}";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
