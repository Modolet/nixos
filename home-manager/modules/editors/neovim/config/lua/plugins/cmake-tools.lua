return {
  "Civitasv/cmake-tools.nvim",
  keys = {
    -- 主要构建命令
    { "<leader>mg", "<cmd>CMakeGenerate<cr>", desc = "CMake Generate" },
    { "<leader>mG", "<cmd>CMakeGenerate!<cr>", desc = "CMake Clean & Generate" },
    { "<leader>mb", "<cmd>CMakeBuild<cr>", desc = "CMake Build" },
    { "<leader>mB", "<cmd>CMakeBuild!<cr>", desc = "CMake Clean & Build" },

    -- 当前文件操作
    { "<leader>mf", "<cmd>CMakeBuildCurrentFile<cr>", desc = "Build Current File" },
    { "<leader>mF", "<cmd>CMakeBuildCurrentFile!<cr>", desc = "Clean & Build Current File" },

    -- 运行和调试
    { "<leader>mr", "<cmd>CMakeRun<cr>", desc = "Run Target" },
    { "<leader>mR", "<cmd>CMakeRunCurrentFile<cr>", desc = "Run Current File" },
    { "<leader>md", "<cmd>CMakeDebug<cr>", desc = "Debug Target" },
    { "<leader>mD", "<cmd>CMakeDebugCurrentFile<cr>", desc = "Debug Current File" },

    -- 测试相关
    { "<leader>mt", "<cmd>CMakeRunTest<cr>", desc = "Run Tests" },

    -- 配置选项
    { "<leader>ms", "<cmd>CMakeSelectBuildType<cr>", desc = "Select Build Type" },
    { "<leader>mk", "<cmd>CMakeSelectKit<cr>", desc = "Select Kit" },
    { "<leader>mp", "<cmd>CMakeSelectConfigurePreset<cr>", desc = "Select Configure Preset" },

    -- 窗口管理
    { "<leader>mo", "<cmd>CMakeOpen<cr>", desc = "Open Executor" },
    { "<leader>mq", "<cmd>CMakeClose<cr>", desc = "Close Executor" },

    -- 实用工具
    { "<leader>mc", "<cmd>CMakeClean<cr>", desc = "Clean Project" },
    { "<leader>mu", "<cmd>CMakeQuickStart<cr>", desc = "Quick Start Project" },
    { "<leader>mv", "<cmd>CMakeSettings<cr>", desc = "CMake Settings" },
  },
  opts = {
    cmake_compile_commands_options = {
      action = "lsp", -- available options: soft_link, copy, lsp, none
      -- soft_link: this will automatically make a soft link from compile commands file to target
      -- copy:      this will automatically copy compile commands file to target
      -- lsp:       this will automatically set compile commands file location using lsp
      -- none:      this will make this option ignored
      -- target = vim.loop.cwd(), -- path to directory, this is used only if action == "soft_link" or action == "copy"
    },
  },
}
