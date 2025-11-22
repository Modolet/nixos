return {
  {
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "Agent service not initialized" },
            },
          },
          opts = { skip = true },
        },
      },
    },
  },
}
