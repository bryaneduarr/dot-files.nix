return {
  "nyoom-engineering/oxocarbon.nvim",
  "sainnhe/everforest",
  "Mofiqul/vscode.nvim",
  "Yazeed1s/oh-lucy.nvim",
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
