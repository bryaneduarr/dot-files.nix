return {
  -- Main plugin repository.
  "yetone/avante.nvim",

  -- Build instructions, this is taken from the official documentation.
  -- Use 'make' for unix, PowerShell for Windows
  -- You can build from source by running 'make BUILD_FROM_SOURCE=true'.
  -- Must set this build setting for proper installation!
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",

  -- Lazy-load the plugin when 'VeryLazy' event triggers.
  event = "VeryLazy",

  -- Always use the latest version; do not set to "*"
  version = false, -- Never set this value to "*"! Never!

  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- Choose the primary AI provider (Copilot)
    provider = "copilot",
    providers = {
      -- Copilot provider configuration
      copilot = {
        model = "gpt-4.1", -- Default model to use with copilot.
        behaviour = {
          enable_cursor_planning_mode = true, -- Enable advanced cursor planning, this is when selecting it will appear options to ask to chat.
        },
      },
    },
    selector = {
      provider = "fzf_lua", -- It can be telescope to.
      provider_opts = {}, -- Options that fzf_lua will follow.
    },
  },

  -- Plugin dependencies
  dependencies = {
    -- Core dependencies
    "nvim-lua/plenary.nvim", -- Utility functions required by Avante.
    "MunifTanjim/nui.nvim", -- UI library for Neovim.

    --- Optional dependencies for extended features.
    "echasnovski/mini.pick", -- Enables file_selector provider.
    "ibhagwan/fzf-lua", -- Enables file_selector provider.
    "stevearc/dressing.nvim", -- Enhanced input UI via dressing provider.
    "echasnovski/mini.icons", -- Icons for better UI experience.
    "zbirenbaum/copilot.lua", -- Required for Copilot provider integration.
    {
      -- Markdown rendering support (especially if lazy-loading)
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
