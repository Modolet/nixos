return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local cmake = require("cmake-tools")
    local color = Snacks.util.color

    opts.sections.lualine_c = {}

    -- CMake 配置信息组 (左侧)
    local configs = {
      {
        function()
          return "󱓻 " .. (cmake.get_configure_preset() or "N/A")
        end,
        cond = function()
          return cmake.has_cmake_preset()
        end,
        color = { fg = color("Comment") },
        on_click = function()
          vim.cmd("CMakeSelectConfigurePreset")
        end,
      },
      {
        function()
          return "󰆧 " .. (cmake.get_build_type() or "Debug")
        end,
        cond = function()
          return not cmake.has_cmake_preset()
        end,
        color = { fg = color("Type") },
        on_click = function()
          vim.cmd("CMakeSelectBuildType")
        end,
      },
      {
        function()
          return "󰅨 " .. (cmake.get_build_target() or "all")
        end,
        color = { fg = color("Identifier") },
        on_click = function()
          vim.cmd("CMakeSelectBuildTarget")
        end,
      },
    }

    -- 操作按钮组 (带分隔符)
    local actions = {
      {
        function()
          return "󰥨"
        end,
        color = { fg = color("String") },
        on_click = function()
          vim.cmd("CMakeBuild")
        end,
      },
      {
        function()
          return "󰁨"
        end,
        color = { fg = color("WarningMsg") },
        on_click = function()
          vim.cmd("CMakeBuild!")
        end,
      },
      -- { separator = "" }, -- 细竖线分隔
      {
        function()
          return ""
        end,
        color = { fg = color("Debug") },
        on_click = function()
          vim.cmd("CMakeDebug")
        end,
      },
      {
        function()
          return ""
        end,
        color = { fg = color("Special") },
        on_click = function()
          vim.cmd("CMakeRun")
        end,
      },
    }

    -- 合并到 lualine_c
    for _, item in ipairs(configs) do
      item.separator = ""
      table.insert(opts.sections.lualine_c, item)
    end
    for _, item in ipairs(actions) do
      item.separator = ""
      table.insert(opts.sections.lualine_c, item)
    end

    -- 统一条件判断
    for _, component in ipairs(opts.sections.lualine_c) do
      if not component.cond then
        component.cond = cmake.is_cmake_project
      end
    end
  end,
}
