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
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # 用户管理
  users.users.modolet = {
    isNormalUser = true;
    description = "modolet";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" "uinput" ];
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

  # Wayland 支持
  programs.xwayland.enable = true;
  programs.hyprland = {
    enable = false;  # 我们使用 Niri
  };

  # Power management
  services.power-profiles-daemon.enable = true;

  # D-Bus 服务
  services.dbus.enable = true;

  # Polkit (权限管理)
  security.polkit.enable = true;

  # 日志管理
  services.journald.extraConfig = ''
    Storage=volatile
    SystemMaxUse=100M
  '';

  # 系统版本
  system.stateVersion = "25.05";
}