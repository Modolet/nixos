{ pkgs, helpers }:

let inherit (helpers) mkUIExtra withVimPlugins;
in {
  ui = {
    alpha = mkUIExtra {
      name = "alpha";
      plugins = withVimPlugins [ "alpha-nvim" "snacks-nvim" ];
    };

    dashboard_nvim = mkUIExtra {
      name = "dashboard-nvim";
      plugins = withVimPlugins [ "dashboard-nvim" "snacks-nvim" ];
    };

    edgy = mkUIExtra {
      name = "edgy";
      plugins = withVimPlugins [
        "edgy-nvim"
        "bufferline-nvim"
        "neo-tree-nvim"
        "telescope-nvim"
      ];
    };

    indent_blankline = mkUIExtra {
      name = "indent-blankline";
      plugins = withVimPlugins [ "indent-blankline-nvim" "snacks-nvim" ];
    };

    mini_animate = mkUIExtra {
      name = "mini-animate";
      plugins = withVimPlugins [ "mini-nvim" "snacks-nvim" ];
    };

    mini_indentscope = mkUIExtra {
      name = "mini-indentscope";
      plugins =
        withVimPlugins [ "mini-nvim" "snacks-nvim" "indent-blankline-nvim" ];
    };

    mini_starter = mkUIExtra {
      name = "mini-starter";
      plugins = withVimPlugins [ "mini-nvim" "snacks-nvim" ];
    };

    smear_cursor = mkUIExtra {
      name = "smear-cursor";
      plugins = withVimPlugins [ "smear-cursor-nvim" "mini-nvim" ];
    };

    treesitter_context = mkUIExtra {
      name = "treesitter-context";
      plugins = withVimPlugins [ "nvim-treesitter-context" ];
    };
  };
}

