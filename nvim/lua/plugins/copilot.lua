return {
  "zbirenbaum/copilot.lua",
  optional = true,
  opts = {
    -- Disable copilot completions in some files.
    filetypes = {
      markdown = false,
      help = false,
      ["."] = false,
    },
  },
}
