{ pkgs, helpers }:

let inherit (helpers) mkCodingExtra withVimPlugins;
in {
  coding = {
    blink = mkCodingExtra {
      name = "blink";
      plugins = withVimPlugins [
        "blink-cmp"
        "friendly-snippets"
        "blink-compat"
        "catppuccin-nvim"
      ];
      defaultEnabled = true;
    };

    yanky = mkCodingExtra {
      name = "yanky";
      plugins = withVimPlugins [ "yanky-nvim" ];
    };

    luasnip = mkCodingExtra {
      name = "luasnip";
      plugins = withVimPlugins [
        "LuaSnip"
        "cmp_luasnip"
        "friendly-snippets"
        "nvim-cmp"
      ];
    };

    mini_comment = mkCodingExtra {
      name = "mini-comment";
      plugins = withVimPlugins [ "mini-nvim" "nvim-ts-context-commentstring" ];
    };

    mini_snippets = mkCodingExtra {
      name = "mini-snippets";
      plugins = withVimPlugins [
        "cmp-mini-snippets"
        "friendly-snippets"
        "mini-nvim"
        "nvim-cmp"
      ];
    };

    mini_surround = mkCodingExtra {
      name = "mini-surround";
      plugins = withVimPlugins [ "mini-nvim" ];
    };

    neogen = mkCodingExtra {
      name = "neogen";
      plugins = withVimPlugins [ "neogen" ];
    };

    nvim_cmp = mkCodingExtra {
      name = "nvim-cmp";
      plugins = withVimPlugins [
        "cmp-buffer"
        "cmp-nvim-lsp"
        "cmp-path"
        "friendly-snippets"
        "nvim-cmp"
        "nvim-snippets"
      ];
    };
  };
}

