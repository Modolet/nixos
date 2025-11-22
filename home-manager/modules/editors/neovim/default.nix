{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  # 基础插件集合
  basePlugins = with pkgs.vimPlugins; [
    # LazyVim 核心
    lazy-nvim
    LazyVim

    # UI 和主题
    bufferline-nvim
    lualine-nvim
    tokyonight-nvim
    catppuccin-nvim
    which-key-nvim

    # 编辑增强
    flash-nvim
    friendly-snippets
    todo-comments-nvim
    trouble-nvim

    # Git 集成
    gitsigns-nvim

    # 基础工具
    plenary-nvim
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    nvim-ts-autotag

    # LSP 和格式化
    conform-nvim
    nvim-lspconfig
    nvim-lint

    # 通知和 UI
    noice-nvim
    nui-nvim

    # 开发工具
    grug-far-nvim
    lazydev-nvim

    # 注释
    ts-comments-nvim

    # 会话管理
    persistence-nvim

    # Snacks (LazyVim 工具集)
    snacks-nvim
  ];

  # 额外插件
  extraPlugins = with pkgs.vimPlugins; [
    # 你自定义的插件
    cmake-tools-nvim
    copilot-lua
    dropbar-nvim
    vim-suda
    yazi-nvim

    # UI 增强
    blink-cmp

    # 工具
    dashboard-nvim
    nvim-dap
  ];

  # 语法高亮
  baseGrammars = [ "lua" "vim" "vimdoc" "query" "regex" "bash" ];

  # 外部依赖
  externalDeps = with pkgs; [
    lua-language-server
    stylua
    ripgrep
    curl
    git
    fd
    lazygit
    fzf
  ];

in {
  options.programs.neovim-lazyvim = {
    enable = mkEnableOption "LazyVim-based Neovim configuration";
    defaultEditor = mkEnableOption "Set Neovim as default editor";
  };

  config = mkIf config.programs.neovim-lazyvim.enable {
    # 设置为默认编辑器
    home.sessionVariables = mkIf config.programs.neovim-lazyvim.defaultEditor {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # 安装外部依赖
    home.packages = externalDeps;

    programs.nixvim = {
      enable = true;
      vimAlias = true;
      enableMan = false;
      withPython3 = false;
      withRuby = false;

      extraPackages = with pkgs; [
        # Neovim 相关工具
        xclip  # 剪贴板支持
      ];

      plugins = basePlugins ++ extraPlugins;

      # 基本设置
      opts = {
        # 缩进设置
        tabstop = 4;
        expandtab = true;
        softtabstop = 4;
        shiftwidth = 4;

        # 文件设置
        swapfile = false;
        spell = false;

        # 其他设置
        number = true;
        relativenumber = true;
        wrap = false;
        signcolumn = "yes";
        colorcolumn = "80";

        # 搜索设置
        ignorecase = true;
        smartcase = true;
        hlsearch = false;

        # 鼠标支持
        mouse = "a";

        # 时间设置
        updatetime = 250;
        timeoutlen = 300;
      };

      # 全局变量
      globals = {
        # 禁用 AI 补全
        ai_cmp = false;

        # Neovide 设置（如果使用）
        neovide_window_blurred = true;
        neovide_floating_shadow = true;
        neovide_floating_z_height = 10;
        neovide_light_angle_degrees = 45;
        neovide_light_radius = 5;
        neovide_cursor_vfx_mode = "railgun";
        neovide_fullscreen = false;
        snacks_animate = false;
      };

      # 按键映射
      keymaps = [
        # 退出插入模式
        {
          mode = "i";
          key = "jj";
          action = "<ESC>";
          options = {
            silent = true;
            noremap = true;
          };
        }
        # 基础映射
        {
          mode = "n";
          key = "H";
          action = "^";
          options = { noremap = true; };
        }
        {
          mode = "n";
          key = "L";
          action = "$";
          options = { noremap = true; };
        }
        {
          mode = "v";
          key = "H";
          action = "^";
          options = { noremap = true; };
        }
        {
          mode = "v";
          key = "L";
          action = "$";
          options = { noremap = true; };
        }
        {
          mode = "n";
          key = "<C-y>";
          action = "\"0y";
          options = { noremap = true; };
        }
        {
          mode = "v";
          key = "<C-y>";
          action = "\"0y";
          options = { noremap = true; };
        }
        {
          mode = "n";
          key = "<C-p>";
          action = "\"0p";
          options = { noremap = true; };
        }
        {
          mode = "v";
          key = "<C-p>";
          action = "\"0p";
          options = { noremap = true; };
        }
      ];

      # 自动命令
      autoCmd = [
        {
          event = [ "BufWritePre" ];
          pattern = [ "*" ];
          callback = {
            __raw = ''
              function()
                if vim.bo.filetype ~= 'markdown' then
                  local save_cursor = vim.fn.getpos('.')
                  vim.cmd([[%s/\s\+$//e]])
                  vim.fn.setpos('.', save_cursor)
                end
              end
            '';
          };
          desc = "Remove trailing whitespace on save (except markdown)";
        }
      ];

      # 额外 Lua 配置（用于 LazyVim 设置）
      extraConfigLua = ''
        -- Lazy.nvim 设置
        require("lazy").setup({
          defaults = {
            lazy = true,
          },
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            { import = "plugins" },

            -- 禁用不需要的 LazyVim 插件
            { "williamboman/mason.nvim", enabled = false },
            { "williamboman/mason-lspconfig.nvim", enabled = false },
            { "jay-babu/mason-nvim-dap.nvim", enabled = false },
            { "WhoIsSethDaniel/mason-tool-installer.nvim", enabled = false },
            { "jay-babu/mason-null-ls.nvim", enabled = false },

            -- TreeSitter 配置
            {
              "nvim-treesitter/nvim-treesitter",
              opts = function(_, opts)
                opts.ensure_installed = {}
                return opts
              end
            },

            -- 自定义插件配置
            {
              "vim-suda/vim-suda",
              lazy = false
            },
          },
          install = { colorscheme = { "tokyonight", "catppuccin" } },
          checker = { enabled = true },
          change_detection = { notify = false },
        })

        -- 字体设置（仅 Neovide）
        if vim.g.neovide then
          vim.o.guifont = "FiraCode Nerd Font Mono:h12"
        end

        -- 缩写
        vim.cmd([[cab cc CodeCompanion]])
      '';
    };

    # TreeSitter parsers 配置
    xdg.configFile = {
      "nvim/parser".source = pkgs.linkFarm "treesitter-parsers" (map
        (grammar: {
          name = "${grammar}.so";
          path = "${pkgs.vimPlugins.nvim-treesitter.builtGrammars.${grammar}}/parser";
        }) baseGrammars);
    };
  };
}