{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.nvim;
  helpers = import ./helpers.nix { inherit lib pkgs; };
  pluginsModule = import ./plugins.nix { inherit lib pkgs helpers; };

  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  inherit (helpers)
    mkExtraOptions
    getAllEnabledExtras
    collectFromExtras
    generateImports
    createLazyPath
    ;
  inherit (pluginsModule)
    basePlugins
    extrasDefinitions
    baseDeps
    lazyDeps
    baseGrammars
    ;

  allEnabledExtras = getAllEnabledExtras {
    inherit (cfg) extras;
    inherit extrasDefinitions;
  };

  allPlugins = basePlugins ++ (collectFromExtras "plugins" allEnabledExtras) ++ cfg.extraPlugins;
  allLspServers = baseDeps ++ (collectFromExtras "lspServers" allEnabledExtras);
  allGrammars = baseGrammars ++ (collectFromExtras "grammars" allEnabledExtras);

  lazyPath = createLazyPath pkgs allPlugins;

  importsSection =
    let
      imports = generateImports allEnabledExtras;
    in
    if imports == "" then "" else ",${imports}";

in
{
  options.modules.nvim = {
    enable = mkEnableOption "nvim";

    extras = lib.genAttrs (lib.attrNames extrasDefinitions) (
      category: mkExtraOptions category extrasDefinitions.${category}
    );

    # 新增的配置项
    configFiles = {
      autocmds = mkOption {
        type = types.nullOr types.path;
        default = ./config/lua/config/autocmds.lua;
        description = "Path to autocmds.lua file to be linked to ~/.config/nvim/lua/config/autocmds.lua";
      };

      keymaps = mkOption {
        type = types.nullOr types.path;
        default = ./config/lua/config/keymaps.lua;
        description = "Path to keymaps.lua file to be linked to ~/.config/nvim/lua/config/keymaps.lua";
      };

      options = mkOption {
        type = types.nullOr types.path;
        default = ./config/lua/config/options.lua;
        description = "Path to options.lua file to be linked to ~/.config/nvim/lua/config/options.lua";
      };
      plugins = mkOption {
        type = types.nullOr types.path;
        default = ./config/lua/plugins;
        description = "Path to plugins directory to be linked to ~/.config/nvim/lua/plugins";
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
        "nvim/parser".source = pkgs.linkFarm "treesitter-parsers" (
          map (grammar: {
            name = "${grammar}.so";
            path = "${pkgs.vimPlugins.nvim-treesitter.builtGrammars.${grammar}}/parser";
          }) allGrammars
        );
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
      withNodeJs = true;

      # 添加 Nix 管理的 treesitter
      extraPackages = [ pkgs.vimPlugins.nvim-treesitter ];

      extraConfigLua =
        let
          stylixColors = config.lib.stylix.colors.withHashtag;
        in
        ''
          -- 将 Stylix 生成的 base16 调色板传入 Lua，供 base16-nvim 使用
          vim.g.stylix_palette = {
            base00 = "${stylixColors.base00}", base01 = "${stylixColors.base01}",
            base02 = "${stylixColors.base02}", base03 = "${stylixColors.base03}",
            base04 = "${stylixColors.base04}", base05 = "${stylixColors.base05}",
            base06 = "${stylixColors.base06}", base07 = "${stylixColors.base07}",
            base08 = "${stylixColors.base08}", base09 = "${stylixColors.base09}",
            base0A = "${stylixColors.base0A}", base0B = "${stylixColors.base0B}",
            base0C = "${stylixColors.base0C}", base0D = "${stylixColors.base0D}",
            base0E = "${stylixColors.base0E}", base0F = "${stylixColors.base0F}",
          }

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
              { "mason-org/mason.nvim", enabled = false },
              { "mason-org/mason-lspconfig.nvim", enabled = false },
              { "jay-babu/mason-nvim-dap.nvim", enabled = false },
              { "WhoIsSethDaniel/mason-tool-installer.nvim", enabled = false },
              { "jay-babu/mason-null-ls.nvim", enabled = false },
              {
                "nvim-treesitter/nvim-treesitter",
                enabled = false,  -- 禁用 lazy 管理，使用 nix 管理的版本
              },
              {
                "nvim-treesitter/nvim-treesitter-textobjects",
                enabled = false,  -- 禁用，与 Nix 管理的 treesitter 冲突
              },
              {
                "nvim-mini/mini.nvim",
                lazy = false,      -- 立即加载，避免被默认 lazy 化
                priority = 1000,   -- 让配色尽早生效
                init = function()
                  local palette = vim.g.stylix_palette
                  if not palette then
                    return
                  end
                  require("mini.base16").setup({
                    palette = palette,
                    use_cterm = true,
                  })
                end,
              },
              {
                dir = "${lazyPath}/vim-suda",
                name = "suda.vim",
                lazy = false
              },
            },
          })



                  local palette = vim.g.stylix_palette
                  if not palette then
                    return
                  end
                  require("mini.base16").setup({
                    palette = palette,
                    use_cterm = true,
                  })
        '';
    };
  };
}
