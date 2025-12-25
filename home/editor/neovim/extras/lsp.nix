{ pkgs, helpers }:

let inherit (helpers) mkCategoryExtra withVimPlugins;
in {
  lsp = {
    neoconf = mkCategoryExtra "lsp" {
      name = "neoconf";
      plugins = withVimPlugins [ "neoconf-nvim" ];
    };

    none_ls = mkCategoryExtra "lsp" {
      name = "none-ls";
      plugins = withVimPlugins [ "none-ls-nvim" ];
    };
  };
}

