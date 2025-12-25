{ config, lib, pkgs, ... }:
let
  stylixColors = config.lib.stylix.colors.withHashtag;
  palette =
    [
      stylixColors.base00
      stylixColors.base01
      stylixColors.base02
      stylixColors.base03
      stylixColors.base04
      stylixColors.base05
      stylixColors.base06
      stylixColors.base07
      stylixColors.base08
      stylixColors.base09
      stylixColors.base0A
      stylixColors.base0B
      stylixColors.base0C
      stylixColors.base0D
      stylixColors.base0E
      stylixColors.base0F
    ];
  paletteArg = lib.concatStringsSep "," palette;
  recolorScript = ''
    ${pkgs.python3.withPackages (ps: with ps; [ pillow tqdm ])}/bin/python ${../../tools/icon-recolor.py} \
      --palette '${paletteArg}' \
      --src "$out/share/icons"
  '';
in {
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";
    targets = {
      gtk.enable = true;
      gtk.flatpakSupport.enable = true;
      qt = {
        enable = true;
        # platform = "gnome";
      };
    };

    polarity = "dark";
    cursor = {
      package = pkgs.graphite-cursors;
      name = "graphite-dark";
      size = 32;
    };
    fonts = {
      monospace.name = "Maple Mono";
      monospace.package = pkgs.maple-mono-variable;
      sansSerif.name = "LXGW WenKai";
      sansSerif.package = pkgs.lxgw-wenkai;
      serif.name = "LXGW WenKai";
      serif.package = pkgs.lxgw-wenkai;
      emoji.name = "Noto Color Emoji";
      emoji.package = pkgs.noto-fonts-color-emoji;
    };
    iconTheme = {
      enable = true;
      package = pkgs.zafiro-icons.overrideAttrs (oldAttrs: {
        postInstall = recolorScript + (oldAttrs.postInstall or "");
      });
      dark = "Zafiro-icons-Dark";
      light = "Zafiro-icons-Light";
    };
  };
}
