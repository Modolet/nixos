{ config, pkgs, lib, inputs, ... }:

{
  # 用户基础信息
  home.username = "modolet";
  home.homeDirectory = "/home/modolet";

  # 引入通用配置模块
  imports = [
    ../modules/default.nix  # 包含 common.nix 和终端模块
    ../modules/editors/neovim
  ];

  # 用户状态版本
  home.stateVersion = "25.05";

  # 启用终端工具配置
  modules.terminal = {
    nushell = {
      enable = true;
      enableStarship = true;
      enableZoxide = true;
      enableDirenv = true;
      enableCarapace = true;
    };
    starship = {
      enable = true;
      useGruvboxRainbow = true;  # 临时方案，后续将由 stylix 动态生成
    };
  };

  # 启用完整的 Neovim 配置
  modules.nvim = {
    enable = true;
    extras = {
      lang = {
        python.enable = true;
        rust.enable = true;
        clangd.enable = true;
        cmake.enable = true;
        json.enable = true;
        markdown.enable = true;
        toml.enable = true;
      };
      dap.core.enable = true;
      editor = {
        inc_rename.enable = true;
        dial.enable = true;
      };
      coding = { yanky.enable = true; };
    };
  };

  # 用户专属配置可以在这里添加
  # 例如特定的开发工具、主题配置等
  programs.home-manager.enable = true;
}