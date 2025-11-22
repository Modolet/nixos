{ inputs, pkgs, lib, config, ... }:

with lib;
let
  cfg = config.modules.terminal.starship;
  # 临时配色方案，后续将由 stylix 动态生成主题
  gruvboxRainbowConfig = ./starship/gruvbox-rainbow.toml;
in
{
  options.modules.terminal.starship = {
    enable = mkEnableOption "Starship prompt with enhanced configuration";

    settings = mkOption {
      type = types.attrs;
      default = {};
      description = "Starship configuration settings (注意：配色将由 stylix 动态生成)";
    };

    # 临时方案：使用 Gruvbox Rainbow 预设配置
    useGruvboxRainbow = mkOption {
      type = types.bool;
      default = false;  # 默认关闭，等待 stylix 集成
      description = "Use the Gruvbox Rainbow preset configuration (临时方案)";
    };

    customConfigFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to custom starship configuration file";
    };
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;

      # 配置优先级：customConfigFile > useGruvboxRainbow > settings
      settings =
        if cfg.customConfigFile != null then {}
        else if cfg.useGruvboxRainbow then (builtins.fromTOML (builtins.readFile gruvboxRainbowConfig))
        else cfg.settings;
    } // optionalAttrs (cfg.customConfigFile != null) {
      settings = {};
    };

    # 如果提供了自定义配置文件路径，则创建对应的配置文件
    home.file = mkIf (cfg.customConfigFile != null) {
      ".config/starship.toml".source = cfg.customConfigFile;
    };

    # 确保 starship 包可用
    home.packages = with pkgs; [ starship ];
  };
}