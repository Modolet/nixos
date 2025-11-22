{ config, pkgs, ... }:

{
  # 通用 home-manager 配置
  # 这里包含所有用户都会使用的通用配置

  # 基础配置
  home.stateVersion = "24.11";

  # 基础包
  home.packages = with pkgs; [
    # 通用工具
    coreutils
    findutils
    gnugrep
    gnused
    gawk
    git

    # 网络工具
    curl
    wget
    htop
    tree
  ];

  # 环境变量
  home.sessionVariables = {
    EDITOR = "nano";  # 临时使用，后续会被 neovim 配置覆盖
    BROWSER = "firefox";
  };

  # 基础配置
  programs.home-manager.enable = true;
}