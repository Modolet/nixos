{
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.drawInTitlebar" = true;
        "browser.tabs.groups.enabled" = true;
        "browser.tabs.groups.smart.enabled" = true;
        "svg.context-properties.content.enabled" = true;
      };
    };
  };
  stylix = {
    targets = {
      firefox = {
        enable = true;
        firefoxGnomeTheme.enable = true;
        profileNames = [ "default" ];
      };
    };
  };
}
