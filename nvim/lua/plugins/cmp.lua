return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "L3MON4D3/LuaSnip",
    "Kaiser-Yang/blink-cmp-avante", -- For avante completions when on the chat.
  },
  version = "1.*",
  opts = {
    completion = {
      list = {
        -- Insert items while navigating the completion list.
        selection = { preselect = false, auto_insert = true },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 0 },
    },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "avante", "lsp", "path", "snippets", "buffer" },
      providers = {
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {}, -- options for blink-cmp-avante.
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
