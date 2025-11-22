return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        ["<c-j>"] = { "select_next", "fallback" },
        ["<c-k>"] = { "select_prev", "fallback" },
        ["<cr>"] = { "accept", "fallback" },
      },
      completion = {
        menu = {
          border = "single",
        },
        documentation = {
          window = {
            border = "single",
          },
        },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
      keymap = {
        accept = "<M-l>",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ['*'] = {
          keys = {
            { "<c-k>", false, mode = "i" },
          },
        },
      },
    },
  },
}
