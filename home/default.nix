{ pkgs, ... }:
{
  imports = [
    ./editor/neovim
    ./style
    ./shell
    ./desktop
    ./ai
    ./lib
    ./im
  ];

  modules.nvim = {
    enable = true;
    extras = {
      lang = {
        python.enable = true;
        rust.enable = true;
        clangd.enable = true;
        cmake.enable = true;
        json.enable = true;
        markdown.enable = true;
        toml.enable = true;
      };
      dap.core.enable = true;
      editor = {
        inc_rename.enable = true;
        dial.enable = true;
      };
      coding = {
        yanky.enable = true;
      };
    };
  };
  modules.wallpaper = {
    enable = true;
  };
  programs = {
    home-manager.enable = true;
  };
  home = {

    username = "modolet";
    homeDirectory = "/home/modolet";
    stateVersion = "25.11";

    packages = with pkgs; [
      fastfetch
    ];
  };

  desktopShell = "dms";
}
