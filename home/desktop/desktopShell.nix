{ lib, config, ... }:
{
  options = {
    desktopShell =
      with lib;
      mkOption {
        type = types.str;
        description = "The desktop shell to use.";
      };

  };
  config = {
    programs.dank-material-shell = {
      enable = config.desktopShell == "dms";
      niri = {
        enableSpawn = false;
        enableKeybinds = false;
        includes.enable = false;
      };
      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dank-material-shell changes
      };
    };
  };
}
