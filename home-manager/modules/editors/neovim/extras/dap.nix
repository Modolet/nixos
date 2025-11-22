{ pkgs, helpers }:

let inherit (helpers) mkCategoryExtra withVimPlugins withPkgs;
in {
  dap = {
    core = mkCategoryExtra "dap" {
      name = "core";
      plugins = withVimPlugins [
        "mason-nvim-dap-nvim"
        "nvim-dap"
        "nvim-dap-ui"
        "nvim-dap-virtual-text"
        "nvim-nio"
      ];
      lspServers = withPkgs [ "lldb" ];
    };

    nlua = mkCategoryExtra "dap" {
      name = "nlua";
      plugins = withVimPlugins [ "nvim-dap" "one-small-step-for-vimkind" ];
    };
  };
}

