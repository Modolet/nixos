{ config, lib, pkgs, ... }:
let
  base16 = "${pkgs.base16-schemes}/share/themes";
  link =
    name: value:
    ''
      rm -rf "$out/specialisation/${lib.escapeShellArg name}"
      ln -s ${value.configuration.home.activationPackage} "$out/specialisation/${lib.escapeShellArg name}"
    '';
in
{
  specialisation = {
    gruvbox.configuration = {
      stylix.base16Scheme = "${base16}/gruvbox-material-dark-soft.yaml";
      stylix.polarity = "dark";
    };

    nord.configuration = {
      stylix.base16Scheme = "${base16}/nord.yaml";
      stylix.polarity = "dark";
    };

    tokyonight.configuration = {
      stylix.base16Scheme = "${base16}/tokyo-night-storm.yaml";
      stylix.polarity = "dark";
    };

    onedark.configuration = {
      stylix.base16Scheme = "${base16}/onedark-dark.yaml";
      stylix.polarity = "dark";
    };

    catppuccin.configuration = {
      stylix.base16Scheme = "${base16}/catppuccin-mocha.yaml";
      stylix.polarity = "dark";
    };

    dracula.configuration = {
      stylix.base16Scheme = "${base16}/dracula.yaml";
      stylix.polarity = "dark";
    };

    solarized-dark.configuration = {
      stylix.base16Scheme = "${base16}/solarized-dark.yaml";
      stylix.polarity = "dark";
    };

    solarized-light.configuration = {
      stylix.base16Scheme = "${base16}/solarized-light.yaml";
      stylix.polarity = lib.mkForce "light";
    };
  };

  home.extraBuilderCommands = lib.mkIf (config.specialisation != { }) (lib.mkAfter ''
    mkdir -p $out/specialisation
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList link config.specialisation)}
  '');
}
