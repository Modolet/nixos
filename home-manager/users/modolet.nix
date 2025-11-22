{ config, pkgs, lib, inputs, ... }:

{
  # 用户基础信息
  home.username = "modolet";
  home.homeDirectory = "/home/modolet";

  # 引入通用配置模块
  imports = [
    ../modules/common.nix
    # 暂时禁用复杂的 neovim 模块进行测试
    # ../modules/editors/neovim
  ];

  # 用户状态版本
  home.stateVersion = "25.05";

  # 使用基础的 nixvim 配置进行测试
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  # 用户专属配置可以在这里添加
  # 例如特定的开发工具、主题配置等
  programs.home-manager.enable = true;
}