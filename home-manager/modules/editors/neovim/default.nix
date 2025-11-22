{ lib, config, pkgs, ... }:

let
  cfg = config.modules.nvim;
  helpers = import ./helpers.nix { inherit lib pkgs; };
  pluginsModule = import ./plugins.nix { inherit lib pkgs helpers; };

  inherit (lib) mkIf mkEnableOption mkOption types;
  inherit (helpers)
    mkExtraOptions getAllEnabledExtras collectFromExtras generateImports
    createLazyPath;
  inherit (pluginsModule)
    basePlugins extrasDefinitions baseDeps lazyDeps baseGrammars;

  allEnabledExtras = getAllEnabledExtras {
    inherit (cfg) extras;
    inherit extrasDefinitions;
  };

  allPlugins = basePlugins ++ (collectFromExtras "plugins" allEnabledExtras)
    ++ cfg.extraPlugins;
  allLspServers = baseDeps ++ (collectFromExtras "lspServers" allEnabledExtras);
  allGrammars = baseGrammars ++ (collectFromExtras "grammars" allEnabledExtras);

  lazyPath = createLazyPath pkgs allPlugins;

  importsSection = let imports = generateImports allEnabledExtras;
  in if imports == "" then "" else ",${imports}";

in {
  options.modules.nvim = {
    enable = mkEnableOption "nvim";

    extras = lib.genAttrs (lib.attrNames extrasDefinitions)
      (category: mkExtraOptions category extrasDefinitions.${category});

    # 新增的配置项
    configFiles = {
      autocmds = mkOption {
        type = types.nullOr types.path;
        default = ./config/lua/config/autocmds.lua;
        description =
          "Path to autocmds.lua file to be linked to ~/.config/nvim/lua/config/autocmds.lua";
      };

      keymaps = mkOption {
        type = types.nullOr types.path;
        default = ./config/lua/config/keymaps.lua;
        description =
          "Path to keymaps.lua file to be linked to ~/.config/nvim/lua/config/keymaps.lua";
      };

      options = mkOption {
        type = types.nullOr types.path;
        default = ./config/lua/config/options.lua;
        description =
          "Path to options.lua file to be linked to ~/.config/nvim/lua/config/options.lua";
      };
      plugins = mkOption {
        type = types.nullOr types.path;
        default = ./config/lua/plugins;
        description =
          "Path to plugins directory to be linked to ~/.config/nvim/lua/plugins";
      };

    };

    extraPlugins = mkOption {
      type = types.listOf types.package;
      default = with pkgs.vimPlugins; [
        cmake-tools-nvim
        copilot-lua
        dropbar-nvim
        vim-suda
        yazi-nvim
      ];
      description = "Additional vim plugins to install";
      example = lib.literalExpression ''
        with pkgs.vimPlugins; [
          telescope-nvim
          nvim-cmp
        ]
      '';
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = lib.mkMerge [
      {
        "nvim/parser".source = pkgs.linkFarm "treesitter-parsers" (map
          (grammar: {
            name = "${grammar}.so";
            path = "${
                pkgs.vimPlugins.nvim-treesitter.builtGrammars.${grammar}
              }/parser";
          }) allGrammars);
      }
      (lib.mkIf (cfg.configFiles.autocmds != null) {
        "nvim/lua/config/autocmds.lua".source = cfg.configFiles.autocmds;
      })
      (lib.mkIf (cfg.configFiles.keymaps != null) {
        "nvim/lua/config/keymaps.lua".source = cfg.configFiles.keymaps;
      })
      (lib.mkIf (cfg.configFiles.options != null) {
        "nvim/lua/config/options.lua".source = cfg.configFiles.options;
      })
      (lib.mkIf (cfg.configFiles.plugins != null) {
        "nvim/lua/plugins".source = cfg.configFiles.plugins;
      })
    ];

    home.packages = allLspServers ++ lazyDeps;

    programs.nixvim = {
      enable = true;
      vimAlias = true;
      enableMan = false;
      withPython3 = false;
      withRuby = false;
      extraConfigLua = ''
        vim.opt.rtp:prepend("${pkgs.vimPlugins.lazy-nvim}")
        require("lazy").setup({
          defaults = {
            lazy = true,
          },
          dev = {
            path = "${lazyPath}",
            patterns = { "" },
            fallback = false,
          },
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" }${importsSection},
            { import = "plugins" },
            { "williamboman/mason.nvim", enabled = false },
            { "williamboman/mason-lspconfig.nvim", enabled = false },
            { "jay-babu/mason-nvim-dap.nvim", enabled = false },
            { "WhoIsSethDaniel/mason-tool-installer.nvim", enabled = false },
            { "jay-babu/mason-null-ls.nvim", enabled = false },
            {
              "nvim-treesitter/nvim-treesitter",
              opts = function(_, opts)
                opts.ensure_installed = {}
                return opts
              end 
            },
            {
              dir = "${lazyPath}/vim-suda",
              name = "suda.vim",
              lazy = false
            },
          },
        })
      '';
    };
  };
}

