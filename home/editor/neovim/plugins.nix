{
  lib,
  pkgs,
  helpers,
}:

let
  inherit (helpers)
    mkExtra
    mkLangExtra
    mkCodingExtra
    mkEditorExtra
    mkUIExtra
    mkAIExtra
    mkCategoryExtra
    withVimPlugins
    withPkgs
    vimPlugins
    miniPlugin
    ;

  # 基础插件定义
  basePluginNames = [
    "mini-nvim"
    "base16-nvim"
    "lazy-nvim"
    "LazyVim"
    "bufferline-nvim"
    "conform-nvim"
    "flash-nvim"
    "friendly-snippets"
    "gitsigns-nvim"
    "grug-far-nvim"
    "lazydev-nvim"
    "lualine-nvim"
    "noice-nvim"
    "nui-nvim"
    "nvim-lint"
    "nvim-lspconfig"
    "nvim-treesitter-textobjects"
    "nvim-ts-autotag"
    "persistence-nvim"
    "plenary-nvim"
    "snacks-nvim"
    "todo-comments-nvim"
    "tokyonight-nvim"
    "trouble-nvim"
    "ts-comments-nvim"
    "which-key-nvim"

    "mason-nvim"
    "mason-nvim-dap-nvim"
    "mason-lspconfig-nvim"
  ];

  miniPlugins = [
    (miniPlugin "ai")
    (miniPlugin "icons")
    (miniPlugin "pairs")
  ];

  specialPlugins = [
    {
      name = "catppuccin";
      path = pkgs.vimPlugins.catppuccin-nvim;
    }
    pkgs.vimPlugins.nvim-treesitter.withAllGrammars
  ];

  basePlugins = (withVimPlugins basePluginNames) ++ miniPlugins ++ specialPlugins;

  # 导入各个分类的extras定义
  codingExtras = import ./extras/coding.nix { inherit pkgs helpers; };
  langExtras = import ./extras/lang.nix { inherit pkgs helpers; };
  editorExtras = import ./extras/editor.nix { inherit pkgs helpers; };
  aiExtras = import ./extras/ai.nix { inherit pkgs helpers; };
  uiExtras = import ./extras/ui.nix { inherit pkgs helpers; };
  dapExtras = import ./extras/dap.nix { inherit pkgs helpers; };
  formattingExtras = import ./extras/formatting.nix { inherit pkgs helpers; };
  lintingExtras = import ./extras/linting.nix { inherit pkgs helpers; };
  lspExtras = import ./extras/lsp.nix { inherit pkgs helpers; };
  utilExtras = import ./extras/util.nix { inherit pkgs helpers; };
  testExtras = import ./extras/test.nix { inherit pkgs helpers; };
  vscodeExtras = import ./extras/vscode.nix { inherit pkgs helpers; };

  # 合并所有extras定义
  extrasDefinitions = {
    inherit (codingExtras) coding;
    inherit (langExtras) lang;
    inherit (editorExtras) editor;
    inherit (aiExtras) ai;
    inherit (uiExtras) ui;
    inherit (dapExtras) dap;
    inherit (formattingExtras) formatting;
    inherit (lintingExtras) linting;
    inherit (lspExtras) lsp;
    inherit (utilExtras) util;
    inherit (testExtras) test;
    inherit (vscodeExtras) vscode;
  };

in
{
  inherit basePlugins extrasDefinitions;

  # 基础依赖包
  baseDeps = withPkgs [
    "lua-language-server"
    "stylua"
    "ripgrep"
    "tree-sitter"
  ];
  lazyDeps = withPkgs [
    "curl"
    "git"
    "ripgrep"
    "fd"
    "lazygit"
    "fzf"
  ];

  # 基础语法高亮
  baseGrammars = [
    "lua"
    "vim"
    "vimdoc"
    "query"
    "regex"
    "bash"
  ];
}
