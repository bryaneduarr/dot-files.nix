local icons = require("config.icons")

return {
  "sindrets/diffview.nvim",
  keys = {
    { "<leader>gf", "<cmd>DiffviewFileHistory<cr>", desc = "File history" },
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff view" },
  },
  opts = function()
    require("diffview.ui.panel").Panel.default_config_float.border = "rounded"

    return {
      default_args = { DiffviewFileHistory = { "%" } },
      icons = {
        folder_closed = icons.symbol_kinds.Folder,
        folder_open = "󰝰",
      },
      signs = {
        fold_closed = icons.arrows.right,
        fold_open = icons.arrows.down,
        done = "",
      },
      hooks = {
        diff_buf_read = function(bufnr)
          -- Register the leader group with miniclue.
          vim.b[bufnr].miniclue_config = {
            clues = {
              { mode = "n", keys = "<leader>G", desc = "+diffview" },
            },
          }
        end,
      },
    }
  end,
}
