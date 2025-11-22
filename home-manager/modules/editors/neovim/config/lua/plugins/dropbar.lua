return {
  {
    "Bekaboo/dropbar.nvim",
    config = true,
    init = function()
      vim.keymap.set("n", "<leader>fm", "<cmd>lua require('dropbar.api').pick()<cr>", { desc = "pick dropbar" })
    end,
  },
}
