{ pkgs, helpers }:

let
  inherit (helpers) mkLangExtra withVimPlugins withPkgs;
in
{
  lang = {
    rust = mkLangExtra {
      lang = "rust";
      plugins = withVimPlugins [
        "crates-nvim"
        "rustaceanvim"
        "neotest"
      ];
      lspServers = withPkgs [ ];
      grammars = [ "rust" ];
    };

    python = mkLangExtra {
      lang = "python";
      plugins = withVimPlugins [
        "neotest-python"
        "nvim-dap-python"
        "mason-nvim-dap-nvim"
        "neotest"
        "nvim-cmp"
        "venv-selector-nvim"
        "nvim-dap"
      ];
      lspServers = withPkgs [
        "pyright"
        "black"
        "isort"
        "ruff"
      ];
      grammars = [ "python" ];
    };

    typescript = mkLangExtra {
      lang = "typescript";
      plugins = withVimPlugins [
        "nvim-dap"
        "mini-nvim"
      ];
      lspServers = withPkgs [ "typescript-language-server" ];
      grammars = [
        "typescript"
        "tsx"
        "javascript"
      ];
    };

    nix = mkLangExtra {
      lang = "nix";
      # lspServers = withPkgs [ "nil" "nixfmt-classic" "statix" ];
      lspServers = withPkgs [
        "nil"
        "nixd"
        "statix"
      ];
      grammars = [ "nix" ];
      defaultEnabled = true;
    };

    json = mkLangExtra {
      lang = "json";
      plugins = withVimPlugins [ "SchemaStore-nvim" ];
      lspServers = withPkgs [ "vscode-langservers-extracted" ];
      grammars = [
        "json"
        "json5"
      ];
    };

    clangd = mkLangExtra {
      lang = "clangd";
      plugins = withVimPlugins [
        "clangd_extensions-nvim"
        "nvim-cmp"
        "nvim-dap"
      ];
      lspServers = withPkgs [ "clang-tools" ];
      grammars = [
        "c"
        "cpp"
      ];
    };

    cmake = mkLangExtra {
      lang = "cmake";
      plugins = withVimPlugins [ "cmake-tools-nvim" ];
      lspServers = withPkgs [
        "cmake-language-server"
        "neocmakelsp"
        "cmake-lint"
      ];
      grammars = [
        "cmake"
      ];
    };

    markdown = mkLangExtra {
      lang = "markdown";
      plugins = withVimPlugins [
        "markdown-preview-nvim"
        "render-markdown-nvim"
      ];
      lspServers = withPkgs [
        "marksman"
        "markdownlint-cli2"
      ];
      grammars = [ "markdown" ];
    };

    toml = mkLangExtra {
      lang = "toml";
      lspServers = withPkgs [ "taplo" ];
      grammars = [ "toml" ];
    };

    angular = mkLangExtra {
      lang = "angular";
      lspServers = withPkgs [ "angular-language-server" ];
      grammars = [ "angular" ];
    };

    ansible = mkLangExtra {
      lang = "ansible";
      plugins = withVimPlugins [ "nvim-ansible" ];
      lspServers = withPkgs [ "ansible-language-server" ];
      grammars = [
        "ansible"
        "yaml"
      ];
    };

    astro = mkLangExtra {
      lang = "astro";
      lspServers = withPkgs [ "astro-language-server" ];
      grammars = [ "astro" ];
    };

    clojure = mkLangExtra {
      lang = "clojure";
      plugins = withVimPlugins [
        "baleia-nvim"
        "cmp-conjure"
        "conjure"
        "nvim-paredit"
        "nvim-cmp"
      ];
      lspServers = withPkgs [ "clojure-lsp" ];
      grammars = [ "clojure" ];
    };

    docker = mkLangExtra {
      lang = "docker";
      lspServers = withPkgs [
        "docker-compose-language-service"
        "dockerfile-language-server-nodejs"
      ];
      grammars = [ "dockerfile" ];
    };

    elixir = mkLangExtra {
      lang = "elixir";
      plugins = withVimPlugins [
        "neotest-elixir"
        "neotest"
        "render-markdown-nvim"
      ];
      lspServers = withPkgs [ "elixir-ls" ];
      grammars = [ "elixir" ];
    };

    elm = mkLangExtra {
      lang = "elm";
      lspServers = withPkgs [ "elm-language-server" ];
      grammars = [ "elm" ];
    };

    erlang = mkLangExtra {
      lang = "erlang";
      lspServers = withPkgs [ "erlang-ls" ];
      grammars = [ "erlang" ];
    };

    git = mkLangExtra {
      lang = "git";
      plugins = withVimPlugins [
        "cmp-git"
        "nvim-cmp"
      ];
      grammars = [
        "git_rebase"
        "gitattributes"
        "gitignore"
      ];
    };

    gleam = mkLangExtra {
      lang = "gleam";
      lspServers = withPkgs [ "gleam" ];
      grammars = [ "gleam" ];
    };

    go = mkLangExtra {
      lang = "go";
      plugins = withVimPlugins [
        "mini-icons"
        "neotest-golang"
        "nvim-dap-go"
        "neotest"
        "nvim-dap"
      ];
      lspServers = withPkgs [
        "gopls"
        "delve"
      ];
      grammars = [
        "go"
        "gomod"
        "gowork"
      ];
    };

    haskell = mkLangExtra {
      lang = "haskell";
      plugins = withVimPlugins [
        "LuaSnip"
        "haskell-snippets-nvim"
        "haskell-tools-nvim"
        "neotest-haskell"
        "telescope-hoogle"
        "neotest"
        "nvim-dap"
        "telescope-nvim"
      ];
      lspServers = withPkgs [ "haskell-language-server" ];
      grammars = [ "haskell" ];
    };

    helm = mkLangExtra {
      lang = "helm";
      plugins = withVimPlugins [ "vim-helm" ];
      lspServers = withPkgs [ "helm-ls" ];
      grammars = [ "helm" ];
    };

    java = mkLangExtra {
      lang = "java";
      plugins = withVimPlugins [
        "nvim-jdtls"
        "which-key-nvim"
        "nvim-dap"
      ];
      lspServers = withPkgs [ "jdt-language-server" ];
      grammars = [ "java" ];
    };

    kotlin = mkLangExtra {
      lang = "kotlin";
      plugins = withVimPlugins [ "nvim-dap" ];
      lspServers = withPkgs [
        "kotlin-language-server"
        "ktlint"
      ];
      grammars = [ "kotlin" ];
    };

    lean = mkLangExtra {
      lang = "lean";
      plugins = withVimPlugins [
        "lean-nvim"
        "plenary-nvim"
      ];
      lspServers = withPkgs [ "lean-language-server" ];
      grammars = [ "lean" ];
    };

    nushell = mkLangExtra {
      lang = "nushell";
      lspServers = withPkgs [ "nu-lsp" ];
      grammars = [ "nu" ];
    };

    ocaml = mkLangExtra {
      lang = "ocaml";
      lspServers = withPkgs [ "ocaml-lsp" ];
      grammars = [ "ocaml" ];
    };

    omnisharp = mkLangExtra {
      lang = "omnisharp";
      plugins = withVimPlugins [
        "neotest-dotnet"
        "omnisharp-extended-lsp-nvim"
        "neotest"
        "nvim-dap"
      ];
      lspServers = withPkgs [ "omnisharp-roslyn" ];
      grammars = [ "csharp" ];
    };

    php = mkLangExtra {
      lang = "php";
      plugins = withVimPlugins [ "nvim-dap" ];
      lspServers = withPkgs [ "phpactor" ];
      grammars = [ "php" ];
    };

    prisma = mkLangExtra {
      lang = "prisma";
      lspServers = withPkgs [ "prisma-language-server" ];
      grammars = [ "prisma" ];
    };

    r = mkLangExtra {
      lang = "r";
      plugins = withVimPlugins [
        "R-nvim"
        "cmp-r"
        "neotest-testthat"
        "neotest"
        "nvim-cmp"
      ];
      lspServers = withPkgs [ "r-languageserver" ];
      grammars = [ "r" ];
    };

    rego = mkLangExtra {
      lang = "rego";
      lspServers = withPkgs [ "regols" ];
      grammars = [ "rego" ];
    };

    ruby = mkLangExtra {
      lang = "ruby";
      plugins = withVimPlugins [
        "neotest-rspec"
        "nvim-dap-ruby"
        "neotest"
        "nvim-dap"
      ];
      lspServers = withPkgs [ "solargraph" ];
      grammars = [ "ruby" ];
    };

    scala = mkLangExtra {
      lang = "scala";
      plugins = withVimPlugins [
        "nvim-metals"
        "nvim-dap"
      ];
      lspServers = withPkgs [ "metals" ];
      grammars = [ "scala" ];
    };

    sql = mkLangExtra {
      lang = "sql";
      plugins = withVimPlugins [
        "vim-dadbod"
        "vim-dadbod-completion"
        "vim-dadbod-ui"
      ];
      lspServers = withPkgs [ "sqlls" ];
      grammars = [ "sql" ];
    };

    svelte = mkLangExtra {
      lang = "svelte";
      lspServers = withPkgs [ "svelte-language-server" ];
      grammars = [ "svelte" ];
    };

    tailwind = mkLangExtra {
      lang = "tailwind";
      plugins = withVimPlugins [
        "tailwindcss-colorizer-cmp-nvim"
        "nvim-cmp"
      ];
      lspServers = withPkgs [ "tailwindcss-language-server" ];
      grammars = [ "css" ];
    };

    terraform = mkLangExtra {
      lang = "terraform";
      plugins = withVimPlugins [
        "telescope-terraform-doc-nvim"
        "telescope-terraform-nvim"
        "telescope-nvim"
      ];
      lspServers = withPkgs [ "terraform-ls" ];
      grammars = [
        "terraform"
        "hcl"
      ];
    };

    tex = mkLangExtra {
      lang = "tex";
      plugins = withVimPlugins [ "vimtex" ];
      lspServers = withPkgs [ "texlab" ];
      grammars = [ "latex" ];
    };

    thrift = mkLangExtra {
      lang = "thrift";
      lspServers = withPkgs [ "thrift-ls" ];
      grammars = [ "thrift" ];
    };

    vue = mkLangExtra {
      lang = "vue";
      lspServers = withPkgs [ "volar" ];
      grammars = [ "vue" ];
    };

    yaml = mkLangExtra {
      lang = "yaml";
      plugins = withVimPlugins [ "SchemaStore-nvim" ];
      lspServers = withPkgs [ "yaml-language-server" ];
      grammars = [ "yaml" ];
    };

    zig = mkLangExtra {
      lang = "zig";
      plugins = withVimPlugins [
        "neotest-zig"
        "neotest"
      ];
      lspServers = withPkgs [ "zls" ];
      grammars = [ "zig" ];
    };
  };
}
