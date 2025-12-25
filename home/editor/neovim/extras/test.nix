{ pkgs, helpers }:

let inherit (helpers) mkCategoryExtra withVimPlugins;
in {
  test = {
    core = mkCategoryExtra "test" {
      name = "core";
      plugins = withVimPlugins [ "neotest" "nvim-nio" "nvim-dap" ];
    };
  };
}

