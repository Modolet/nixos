{ pkgs, config, ... }:
{
  imports = [
    ./editor/neovim
    ./style
    ./shell
    ./desktop
    ./ai
    ./lib
    ./im
    ./develop
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

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
    videos = "${config.home.homeDirectory}/Videos";
  };

  desktopShell = "dms";
}
