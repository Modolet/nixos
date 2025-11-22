{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/common.nix
  ];

  # 系统基础配置
  networking.hostName = "vm-nixos";

  # 用户管理
  users.users.modolet = {
    isNormalUser = true;
    description = "modolet";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.bash;
  };

  # 允许非自由软件
  nixpkgs.config.allowUnfree = true;

  # VMware 虚拟机特定配置
  virtualisation.vmware.guest = {
    enable = true;
  };

  # 虚拟机特有的系统包
  environment.systemPackages = with pkgs; [
    open-vm-tools    # VMware guest tools
  ];

  # 系统版本
  system.stateVersion = "25.05";

  # 引入 home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.modolet = import ./home.nix;
  };
}