{
  config,
  pkgs,
  ...
}:
{
  config.lib.niri.actions = {
    # 窗口操作
    "close-window" = "close-window";
    "toggle-column-tabbed-display" = "toggle-column-tabbed-display";
    "focus-column-left" = "focus-column-left";
    "focus-column-right" = "focus-column-right";
    "focus-column-left-or-monitor-left" = "focus-column-left-or-monitor-left";
    "focus-column-right-or-monitor-right" = "focus-column-right-or-monitor-right";
    "focus-window-or-workspace-down" = "focus-window-or-workspace-down";
    "focus-window-or-workspace-up" = "focus-window-or-workspace-up";
    "focus-monitor-left" = "focus-monitor-left";
    "focus-monitor-right" = "focus-monitor-right";
    "focus-monitor-down" = "focus-monitor-down";
    "focus-monitor-up" = "focus-monitor-up";

    # 窗口移动
    "move-column-left-or-to-monitor-left" = "move-column-left-or-to-monitor-left";
    "move-column-right-or-to-monitor-right" = "move-column-right-or-to-monitor-right";
    "move-window-down-or-to-workspace-down" = "move-window-down-or-to-workspace-down";
    "move-window-up-or-to-workspace-up" = "move-window-up-or-to-workspace-up";
    "move-window-to-monitor-left" = "move-window-to-monitor-left";
    "move-window-to-monitor-right" = "move-window-to-monitor-right";
    "move-window-to-monitor-down" = "move-window-to-monitor-down";
    "move-window-to-monitor-up" = "move-window-to-monitor-up";

    # 窗口状态
    "toggle-window-floating" = "toggle-window-floating";
    "switch-focus-between-floating-and-tiling" = "switch-focus-between-floating-and-tiling";
    "toggle-overview" = "toggle-overview";
    "toggle-windowed-fullscreen" = "toggle-windowed-fullscreen";
    "toggle-maximized" = "toggle-maximized";

    # 工作区操作
    "focus-workspace-1" = "focus-workspace 1";
    "focus-workspace-2" = "focus-workspace 2";
    "focus-workspace-3" = "focus-workspace 3";
    "focus-workspace-4" = "focus-workspace 4";
    "focus-workspace-5" = "focus-workspace 5";
    "focus-workspace-6" = "focus-workspace 6";
    "focus-workspace-7" = "focus-workspace 7";
    "focus-workspace-8" = "focus-workspace 8";
    "focus-workspace-9" = "focus-workspace 9";
    "move-window-to-workspace-1" = "move-window-to-workspace 1";
    "move-window-to-workspace-2" = "move-window-to-workspace 2";
    "move-window-to-workspace-3" = "move-window-to-workspace 3";
    "move-window-to-workspace-4" = "move-window-to-workspace 4";
    "move-window-to-workspace-5" = "move-window-to-workspace 5";
    "move-window-to-workspace-6" = "move-window-to-workspace 6";
    "move-window-to-workspace-7" = "move-window-to-workspace 7";
    "move-window-to-workspace-8" = "move-window-to-workspace 8";
    "move-window-to-workspace-9" = "move-window-to-workspace 9";

    # 列布局操作
    "consume-window-into-column" = "consume-window-into-column";
    "expel-window-from-column" = "expel-window-from-column";
    "switch-preset-column-width" = "switch-preset-column-width";
    "maximize-column" = "maximize-column";

    # 窗口大小调整
    "set-column-width-minus" = "set-column-width -10%";
    "set-column-width-plus" = "set-column-width +10%";
    "set-window-height-minus" = "set-window-height -10%";
    "set-window-height-plus" = "set-window-height +10%";

    # 浮动窗口移动
    "move-floating-window-left" = "move-floating-window -10";
    "move-floating-window-right" = "move-floating-window +10";
    "move-floating-window-up" = "move-floating-window -10";
    "move-floating-window-down" = "move-floating-window +10";

    # 截图操作
    "screenshot" = "screenshot";
    "screenshot-window" = "screenshot-window";
    "screenshot-screen" = "screenshot-screen";

    # 其他操作
    "center-column" = "center-column";
    "set-dynamic-cast-monitor" = "set-dynamic-cast-monitor";
    "set-dynamic-cast-window" = "set-dynamic-cast-window";
    "clear-dynamic-cast-target" = "clear-dynamic-cast-target";
  };
}