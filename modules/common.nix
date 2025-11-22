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
    settings.PasswordAuthentication = true;
    # 允许空密码（仅在密码设置为空时有效）
    settings.PermitEmptyPasswords = false;
    # 启用公钥认证
    settings.PubkeyAuthentication = true;
    # 开启 X11 转发（可选）
    settings.X11Forwarding = true;
  };

  # 网络配置
  networking.networkmanager.enable = lib.mkDefault true;

  # 用户管理基础配置
  users.users.root.openssh.authorizedKeys.keys = [
    # 添加 root 用户的 SSH 公钥
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAClwiLBbqNbudTCro4BZQGBH09tavx2ru2z7bPA2JTtjSrRkipXZYE4IbBzLQWPFodEosI6AC8zMil3DK15cXP2KbyEOIDoc/yY439x9k05GbX+qnpjV9y58RQNo4yTVwZjDRZn7ujc3LfCO5UCpq/woPdpKPDv83vo0BHRi4WfaP/NV17KRfsWxy7i3MyAZEiH/580qs6SW3dKAavBiZeEdfxvH76877spUrL1rM47qQfwWOdG5mPD5jU3D23FV+67NrgLm2dAn5MI8Lx7Zsh51/Po2Rx9OfLmx+wsX37tvSqfAp83Oqv2kCEQG8fWM9FiXyl55GzDz8op92g123LFy6ex+bS/sS7dvoFwy4bbMLK0ZnrTWT9MZ9GTLTFLnHfQsvh2kYpZZOPALXUg/dJ/WU5rn3vOtxQvVDN+OqRtjPcUnjwWyygaRzgOZeMW2BEbbc6jlaGfrkWmevGXCJQOMWKBi8bGCMrKr8Bx54KaaRK0gQNawO4/F2MVtiNAN13iLiOFh1hrVX9CE9AUlebwIBs9VbQ6/GgXiT7LAOBU3/iIwbSse6S7v2nTdDO+odOubmP9BfCrAp6bbXSGZ/N9dnnJmP5HJf4IzxBephtdSvCaaKQ04ji+cxKSj2CB13NjeiyVhRDdX2mqfwOeyvn/gBapkvN0ZMrKWBSToL1w== y@xxyx.io"
  ];
}