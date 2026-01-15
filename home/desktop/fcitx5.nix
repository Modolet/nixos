{ pkgs, config, ... }:
with config.lib.stylix.colors;
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        libsForQt5.fcitx5-qt
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk
        (fcitx5-rime.override { rimeDataPkgs = [ rime-ice ]; })
      ];
      waylandFrontend = true;
    };

  };
  home.sessionVariables = {
    QT_IM_MODULE = "fcitx";
  };
  xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
    patch:
        __include: rime_ice_suggestion:/
        menu/page_size: 9
        key_binder/bindings:
            - { when: paging, accept: bracketleft, send: Page_Up }
            - { when: paging, accept: bracketright, send: Page_Down }
  '';
  xdg.dataFile."fcitx5/themes/stylix/theme.conf".text = ''
    [Metadata]
    Name=stylix
    Version=0.2
    Author=justTOBBI and Isabelinc
    ScaleWithDPI=True

    [InputPanel]
    # 字体
    Font=Sans 13
    # 非选中候选字颜色
    #Blue
    NormalColor=#${base0D}
    # 选中候选字颜色
    #Peach
    HighlightCandidateColor=#${base00}
    # 高亮前景颜色(输入字符颜色)
    #Peach
    HighlightColor=#${base07}
    # 输入字符背景颜色
    # Black3/surface0
    HighlightBackgroundColor=#${base02}
    #
    Spacing=3

    [InputPanel/TextMargin]
    # 候选字对左边距
    Left=10
    # 候选字对右边距
    Right=10
    # 候选字向上边距
    Top=6
    # 候选字向下边距
    Bottom=6

    [InputPanel/Background]
    #Black3/surface0
    Color=#${base01}
    #Black3/surface0
    BorderColor=#${base0E}
    BorderWidth=0

    [InputPanel/Background/Margin]
    Left=2
    Right=2
    Top=2
    Bottom=2

    [InputPanel/Highlight]
    #Black3/surface0
    Color=#${base0E}

    [InputPanel/Highlight/Margin]
    # 高亮区域左边距
    Left=10
    # 高亮区域右边距
    Right=10
    # 高亮区域上边距
    Top=7
    # 高亮区域下边距
    Bottom=7

    [Menu]
    Font=Sans 10
    #White/Text
    NormalColor=#${base05}
    #HighlightColor=#4c566a
    Spacing=3

    [Menu/Background]
    #Black3/surface0
    Color=#${base02}

    [Menu/Background/Margin]
    Left=2
    Right=2
    Top=2
    Bottom=2

    [Menu/ContentMargin]
    Left=2
    Right=2
    Top=2
    Bottom=2

    [Menu/Highlight]
    #Pink
    Color=#${base0E}

    [Menu/Highlight/Margin]
    Left=10
    Right=10
    Top=5
    Bottom=5

    [Menu/Separator]
    #Black2/base
    Color=#${base00}

    [Menu/TextMargin]
    Left=5
    Right=5
    Top=5
    Bottom=5
  '';
}
