{ pkgs, helpers }:

let inherit (helpers) mkAIExtra withVimPlugins withPkgs;
in {
  ai = {
    copilot = mkAIExtra {
      name = "copilot";
      plugins = withVimPlugins [
        "blink-copilot"
        "copilot-cmp"
        "copilot-lua"
        "blink-cmp"
        "lualine-nvim"
        "nvim-cmp"
      ];
    };

    codeium = mkAIExtra {
      name = "codeium";
      plugins = withVimPlugins [
        "blink-compat"
        "codeium-nvim"
        "blink-cmp"
        "lualine-nvim"
        "nvim-cmp"
      ];
      lspServers = withPkgs [ "codeium" ];
    };

    copilot_chat = mkAIExtra {
      name = "copilot-chat";
      plugins = withVimPlugins [ "CopilotChat-nvim" "blink-cmp" ];
    };

    supermaven = mkAIExtra {
      name = "supermaven";
      plugins = withVimPlugins [
        "blink-compat"
        "supermaven-nvim"
        "blink-cmp"
        "lualine-nvim"
        "noice-nvim"
        "nvim-cmp"
      ];
    };

    tabnine = mkAIExtra {
      name = "tabnine";
      plugins = withVimPlugins [
        "blink-compat"
        "cmp-tabnine"
        "blink-cmp"
        "lualine-nvim"
        "nvim-cmp"
      ];
    };
  };
}

