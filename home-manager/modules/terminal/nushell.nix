{ inputs, pkgs, lib, config, ... }:

with lib;
let
  cfg = config.modules.terminal.nushell;
in
{
  options.modules.terminal.nushell = {
    enable = mkEnableOption "Nushell with enhanced configuration";

    package = mkOption {
      type = types.package;
      default = pkgs.nushell;
      description = "The Nushell package to use";
    };

    configFile = mkOption {
      type = types.path;
      default = ./nushell/config.nu;
      description = "Path to the nushell config file";
    };

    envFile = mkOption {
      type = types.path;
      default = ./nushell/env.nu;
      description = "Path to the nushell environment file";
    };

    enableStarship = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Starship prompt integration";
    };

    enableZoxide = mkOption {
      type = types.bool;
      default = true;
      description = "Enable zoxide directory jumper integration";
    };

    enableDirenv = mkOption {
      type = types.bool;
      default = true;
      description = "Enable direnv integration";
    };

    enableCarapace = mkOption {
      type = types.bool;
      default = true;
      description = "Enable carapace completion integration";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional Nushell configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      package = cfg.package;
      configFile.source = cfg.configFile;
      envFile.source = cfg.envFile;
      extraConfig = cfg.extraConfig;
    };

    programs.starship = mkIf cfg.enableStarship {
      enable = true;
      enableNushellIntegration = true;
    };

    programs.zoxide = mkIf cfg.enableZoxide {
      enable = true;
      enableNushellIntegration = true;
    };

    programs.direnv = mkIf cfg.enableDirenv {
      enable = true;
      nix-direnv.enable = true;
      enableNushellIntegration = true;
    };

    programs.carapace = mkIf cfg.enableCarapace {
      enable = true;
      enableNushellIntegration = true;
    };

    # Ensure required packages are available
    home.packages = with pkgs; [
      cfg.package
    ] ++ optionals cfg.enableStarship [ starship ]
      ++ optionals cfg.enableZoxide [ zoxide ]
      ++ optionals cfg.enableDirenv [ direnv nix-direnv ]
      ++ optionals cfg.enableCarapace [ carapace ];
  };
}