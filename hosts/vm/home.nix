{ pkgs, config, ... }:

{
  # 引入 modolet 用户的配置
  imports = [
    ../../home-manager/users/modolet.nix
  ];

  # 虚拟机特有的用户配置可以在这里添加
  # 例如：特定的开发环境、显示设置等
}