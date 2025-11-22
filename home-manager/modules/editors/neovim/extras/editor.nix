{ pkgs, helpers }:

let inherit (helpers) mkEditorExtra withVimPlugins;
in {
  editor = {
    telescope = mkEditorExtra {
      name = "telescope";
      plugins = withVimPlugins [
        "dressing-nvim"
        "telescope-fzf-native-nvim"
        "telescope-nvim"
      ];
    };

    neo_tree = mkEditorExtra {
      name = "neo-tree";
      plugins = withVimPlugins [ "neo-tree-nvim" ];
    };

    snacks_explorer = mkEditorExtra {
      name = "snacks_explorer";
      plugins = withVimPlugins [ "snacks-nvim" ];
    };

    snacks_picker = mkEditorExtra {
      name = "snacks_picker";
      plugins = withVimPlugins [
        "snacks-nvim"
        "alpha-nvim"
        "dashboard-nvim"
        "flash-nvim"
        "mini-nvim"
        "todo-comments-nvim"
      ];
    };

    dial = mkEditorExtra {
      name = "dial";
      plugins = withVimPlugins [ "dial-nvim" ];
    };

    inc_rename = mkEditorExtra {
      name = "inc-rename";
      plugins = withVimPlugins [ "inc-rename-nvim" "noice-nvim" ];
    };

    aerial = mkEditorExtra {
      name = "aerial";
      plugins = withVimPlugins [
        "aerial-nvim"
        "lualine-nvim"
        "telescope-nvim"
        "trouble-nvim"
      ];
    };

    fzf = mkEditorExtra {
      name = "fzf";
      plugins = withVimPlugins [ "fzf-lua" "todo-comments-nvim" ];
    };

    harpoon2 = mkEditorExtra {
      name = "harpoon2";
      plugins = withVimPlugins [ "harpoon" ];
    };

    illuminate = mkEditorExtra {
      name = "illuminate";
      plugins = withVimPlugins [ "snacks-nvim" "vim-illuminate" ];
    };

    leap = mkEditorExtra {
      name = "leap";
      plugins =
        withVimPlugins [ "flit-nvim" "leap-nvim" "vim-repeat" "mini-nvim" ];
    };

    mini_diff = mkEditorExtra {
      name = "mini-diff";
      plugins = withVimPlugins [ "lualine-nvim" "mini-nvim" ];
    };

    mini_files = mkEditorExtra {
      name = "mini-files";
      plugins = withVimPlugins [ "mini-nvim" ];
    };

    mini_move = mkEditorExtra {
      name = "mini-move";
      plugins = withVimPlugins [ "mini-nvim" ];
    };

    navic = mkEditorExtra {
      name = "navic";
      plugins = withVimPlugins [ "nvim-navic" "lualine-nvim" ];
    };

    outline = mkEditorExtra {
      name = "outline";
      plugins = withVimPlugins [ "outline-nvim" "trouble-nvim" ];
    };

    overseer = mkEditorExtra {
      name = "overseer";
      plugins = withVimPlugins [
        "overseer-nvim"
        "catppuccin-nvim"
        "neotest"
        "nvim-dap"
        "which-key-nvim"
      ];
    };

    refactoring = mkEditorExtra {
      name = "refactoring";
      plugins = withVimPlugins [ "plenary-nvim" "refactoring-nvim" ];
    };
  };
}

