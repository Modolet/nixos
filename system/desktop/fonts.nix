{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
    nerd-fonts.hurmit
    nerd-fonts.monofur
    lxgw-wenkai
    apple-fonts
    # maple-mono-variable
    maple-mono.NF-CN
  ];
  fonts.fontDir.enable = true;
}
