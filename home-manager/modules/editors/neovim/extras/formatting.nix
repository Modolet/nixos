{ pkgs, helpers }:

let inherit (helpers) mkCategoryExtra withVimPlugins withPkgs;
in {
  formatting = {
    biome = mkCategoryExtra "formatting" {
      name = "biome";
      plugins = withVimPlugins [ "conform-nvim" ];
      lspServers = withPkgs [ "biome" ];
    };

    black = mkCategoryExtra "formatting" {
      name = "black";
      plugins = withVimPlugins [ "conform-nvim" ];
      lspServers = withPkgs [ "black" ];
    };

    prettier = mkCategoryExtra "formatting" {
      name = "prettier";
      plugins = withVimPlugins [ "conform-nvim" ];
      lspServers = withPkgs [ "prettierd" ];
    };
  };
}

