{ pkgs, ... }:
{

  home.packages = with pkgs; [
    qq
    wechat
    nur.repos.xddxdd.dingtalk
    nur.repos.xddxdd.baidunetdisk
  ];

}
