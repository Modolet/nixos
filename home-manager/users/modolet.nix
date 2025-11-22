{ pkgs, lib, config, ... }:

{
  # 用户基础信息
  home.username = "modolet";
  home.homeDirectory = "/home/modolet";

  # 引入通用配置模块
  imports = [
    ../modules/common.nix
  ];

  # 用户状态版本
  home.stateVersion = "25.05";

  # 用户专属配置可以在这里添加
  # 例如特定的开发工具、主题配置等
  programs.home-manager.enable = true;
}