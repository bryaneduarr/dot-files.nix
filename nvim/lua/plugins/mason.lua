return {
  "williamboman/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        border = "rounded",
      },
    })

    -- Install LSP servers and tools needed.
    mason_tool_installer.setup({
      ensure_installed = {
        -- LSP servers (for the new built-in LSP system)
        "typescript-language-server", -- ts_ls
        "html-lsp", -- html
        "css-lsp", -- cssls
        "tailwindcss-language-server", -- tailwindcss
        "lua-language-server", -- lua_ls
        "emmet-ls", -- emmet_ls

        -- Formatters
        "stylua", -- lua formatter.
        "prettier", -- js/ts/html/css formatter (for monorepos).
        "prettierd", -- js/ts/html/css formatter (daemon version).
        "eslint_d", -- js/ts linter.
      },
    })
  end,
}
