return {
  "lukas-reineke/indent-blankline.nvim",
  enabled = true,
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  opts = {
    scope = {
      show_start = false,
    },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
  end,
}
