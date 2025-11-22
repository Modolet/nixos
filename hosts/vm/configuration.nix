{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/common.nix
  ];

  # 系统基础配置
  networking.hostName = "vm-nixos";

  # 启动加载器配置 (EFI)
  boot.loader.grub = {
    enable = true;
    efiSupport = true; # 启用EFI支持
    device = "nodev"; # 无特定设备，EFI处理启动
    version = 2;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # 用户管理
  users.users.modolet = {
    isNormalUser = true;
    description = "modolet";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.nushell;
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
}