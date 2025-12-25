{ pkgs, helpers }:

let inherit (helpers) mkCategoryExtra withVimPlugins withPkgs;
in {
  util = {
    dot = mkCategoryExtra "util" {
      name = "dot";
      grammars = [ "dot" ];
    };

    mini_hipatterns = mkCategoryExtra "util" {
      name = "mini-hipatterns";
      plugins = withVimPlugins [ "mini-nvim" ];
    };

    chezmoi = mkCategoryExtra "util" {
      name = "chezmoi";
      plugins = withVimPlugins [
        "chezmoi-nvim"
        "chezmoi-vim"
        "mini-icons"
        "dashboard-nvim"
        "snacks-nvim"
      ];
    };

    gitui = mkCategoryExtra "util" {
      name = "gitui";
      lspServers = withPkgs [ "gitui" ];
    };

    octo = mkCategoryExtra "util" {
      name = "octo";
      plugins = withVimPlugins [ "octo-nvim" ];
    };

    project = mkCategoryExtra "util" {
      name = "project";
      plugins = withVimPlugins [
        "project-nvim"
        "alpha-nvim"
        "dashboard-nvim"
        "fzf-lua"
        "mini-nvim"
        "snacks-nvim"
        "telescope-nvim"
      ];
    };

    rest = mkCategoryExtra "util" {
      name = "rest";
      plugins = withVimPlugins [ "kulala-nvim" ];
      grammars = [ "http" ];
    };

    startuptime = mkCategoryExtra "util" {
      name = "startuptime";
      plugins = withVimPlugins [ "vim-startuptime" ];
    };
  };
}

