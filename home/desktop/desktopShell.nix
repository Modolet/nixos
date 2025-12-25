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
        enableSpawn = true;
      };
    };

  };
}
