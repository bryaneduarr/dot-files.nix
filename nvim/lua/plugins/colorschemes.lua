return {
  "nyoom-engineering/oxocarbon.nvim",
  "sainnhe/everforest",
  "Mofiqul/vscode.nvim",
  "Yazeed1s/oh-lucy.nvim",
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function(_, _)
      -- vim.cmd.colorscheme("catppuccin-mocha")
      -- Transparency for the color-scheme.
      -- vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
      -- Transparency for inactive windows.
      -- vim.cmd([[hi NormalNC guibg=NONE ctermbg=NONE]])
    end,
  },
  {
    "dgox16/oldworld.nvim",
    opts = {
      variant = "default",
    },
    config = function(_, _)
      vim.cmd.colorscheme("oldworld")
      -- Transparency for the color-scheme.
      -- vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
      -- Transparency for inactive windows.
      -- vim.cmd([[hi NormalNC guibg=NONE ctermbg=NONE]])
    end,
  },
  {
    "sainnhe/gruvbox-material",
  },
}
