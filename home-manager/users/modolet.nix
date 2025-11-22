{ config, pkgs, lib, inputs, ... }:

{
  # 用户基础信息
  home.username = "modolet";
  home.homeDirectory = "/home/modolet";

  # 引入通用配置模块
  imports = [
    ../lib  # 导入自定义库函数到 config.lib
    ../modules/common.nix  # 包含通用配置
    ../modules/terminal  # 终端模块
    ../modules/editors/neovim
    ../modules/desktop  # 桌面环境
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

  # 设置默认 shell 为 nushell
  programs.nushell.enable = true;
  home.sessionVariables = {
    SHELL = "${pkgs.nushell}/bin/nu";
  };

  
  # 显示器配置
  monitors = {
    main = "eDP-1";
    others = [ ];
  };

  # 色彩方案配置
  colorSchemes = [
    {
      name = "default-dark";
      isDefault = true;
      polarity = "dark";
    }
  ];

  # 壁纸配置
  wallpapers = [
    {
      name = "default";
      path = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-tiling-rainbow.png";
        sha256 = "1n6p1z6z7l20qgmpfqd0j0q7yf6dzhj8a55q8871l5h8v4x0kl1";
      };
      convertMethod = "none";
    }
  ];

  # 桌面 shell 配置
  desktopShell = "waybar";

  # 用户专属配置可以在这里添加
  # 例如特定的开发工具、主题配置等
  programs.home-manager.enable = true;
}