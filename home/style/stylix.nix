{ lib, pkgs, ... }: {
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
      # package = pkgs.zafiro-icons.overrideAttrs (oldAttrs: {
      #   postInstall = recolorScript + (oldAttrs.postInstall or "");
      # });
      package = pkgs.zafiro-icons;
      dark = "Zafiro-icons-Dark";
      light = "Zafiro-icons-Light";
    };
  };
}
