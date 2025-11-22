{ inputs, pkgs, ... }:
{
  imports = [
    ./tofi.nix
    ./fonts.nix
    ./mako.nix
    ./niri
    ./monitors.nix
    ./colorscheme.nix
    ./wallpaper.nix
    ./desktop-shell.nix
  ];

  home.packages = with pkgs; [
    swww
    swaybg
    kanshi
    wlsunset
    wayneko
    xwayland-satellite
    wmname
    waycorner
    wshowkeys
    wl-color-picker
    yad
    jq
    sd
    libnotify
    power-profiles-daemon
  ];

  # 脚本文件
  home.file."scripts" = {
    source = ../../../../scripts;
    recursive = true;
  };

  # 环境变量
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3";
  };

  # 服务
  services.wl-clip-persist.enable = true;

  # Stylix 主题系统集成
  stylix = {
    enable = true;
    autoEnable = true;
    targets = {
      waybar.enable = true;
      mako.enable = true;
    };
  };
}