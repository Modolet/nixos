{ config, pkgs, lib, ... }:

{
  # 通用 NixOS 系统配置
  # 这里包含所有主机都会使用的通用系统配置

  # 基础系统配置
  system.stateVersion = "25.05";

  # 国际化
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # 时区
  time.timeZone = "Asia/Shanghai";

  # 基础包
  environment.systemPackages = with pkgs; [
    # 基础工具
    vim
    nano
    git
    curl
    wget
    htop
    tree
    file
    which
  ];

  # SSH 服务配置
  services.openssh = {
    enable = true;
    # 允许 root 用户通过 SSH 登录
    settings.PermitRootLogin = "yes";
    # 允许密码认证
    settings.PasswordAuthentication = "yes";
    # 允许空密码（仅在密码设置为空时有效）
    settings.PermitEmptyPasswords = "no";
    # 启用公钥认证
    settings.PubkeyAuthentication = "yes";
    # 开启 X11 转发（可选）
    settings.X11Forwarding = "yes";
  };

  # 网络配置
  networking.networkmanager.enable = lib.mkDefault true;

  # 用户管理基础配置
  users.users.root.openssh.authorizedKeys.keys = [
    # 添加 root 用户的 SSH 公钥（可选）
    # "ssh-rsa your-public-key-here"
  ];
}