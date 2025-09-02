return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-mini/mini.icons" },
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      -- Global settings.
      global_resume = true,
      global_resume_query = true,
      winopts = {
        height = 0.85,
        width = 0.80,
        row = 0.35,
        col = 0.55,
        border = "rounded",
        preview = {
          border = "border",
          wrap = "nowrap",
          hidden = "nohidden",
          vertical = "down:45%",
          horizontal = "right:60%",
        },
      },
      keymap = {
        builtin = {
          ["<c-d>"] = "preview-page-down",
          ["<c-u>"] = "preview-page-up",
        },
        fzf = {
          ["ctrl-d"] = "delete-char",
          ["ctrl-a"] = "beginning-of-line",
          ["ctrl-e"] = "end-of-line",
        },
      },
      -- Files configuration with ignore patterns.
      files = {
        prompt = "Files❯ ",
        multiprocess = true,
        file_icons = true,
        color_icons = true,
        git_icons = true,
        -- Apply ignore patterns.
        fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude .next --exclude .obsidian --exclude .smart-env",
        find_opts = [[-type f -not -path '*/\.git/*' -not -path '*/node_modules/*' -not -path '*/.next/*' -not -path '*/.obsidian/*' -not -path '*/.smart-env/*' -printf '%P\n']],
      },
      -- Grep configuration.
      grep = {
        prompt = "Rg❯ ",
        input_prompt = "Grep For❯ ",
        multiprocess = true,
        git_icons = true,
        file_icons = true,
        color_icons = true,
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --follow --glob '!.git/' --glob '!node_modules/' --glob '!.next/' --glob '!.obsidian/' --glob '!.smart-env/'",
      },
      -- Buffers configuration.
      buffers = {
        prompt = "Buffers❯ ",
        file_icons = true,
        color_icons = true,
        sort_lastused = true,
        actions = {
          ["ctrl-d"] = function(selected)
            local buf = selected[1]:match("(%d+)")
            if buf then
              vim.cmd("bdelete " .. buf)
            end
          end,
        },
      },
      -- Git configuration
      git = {
        status = {
          prompt = "GitStatus❯ ",
          preview_pager = "delta --width=$COLUMNS",
        },
        commits = {
          prompt = "Commits❯ ",
          preview_pager = "delta --width=$COLUMNS",
        },
      },
      -- Oldfiles configuration
      oldfiles = {
        prompt = "History❯ ",
        cwd_only = false,
        stat_file = true,
        include_current_session = true,
      },
      -- Keymaps configuration
      keymaps = {
        prompt = "Keymaps❯ ",
      },
      -- Colorschemes with preview
      colorschemes = {
        prompt = "Colorschemes❯ ",
        live_preview = true,
        actions = {
          ["default"] = function(selected)
            vim.cmd("colorscheme " .. selected[1])
          end,
        },
      },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>ff", function()
      fzf.files()
    end, { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fg", function()
      fzf.live_grep()
    end, { desc = "Fuzzy find string in cwd" })
    keymap.set("n", "<leader>fb", function()
      fzf.buffers()
    end, { desc = "Find opened buffers" })
    keymap.set("n", "<leader>fs", function()
      fzf.git_status()
    end, { desc = "Fuzzy find git status" })
    keymap.set("n", "<leader>fc", function()
      fzf.git_commits()
    end, { desc = "Find git commits" })
    keymap.set("n", "<leader>fr", function()
      fzf.oldfiles()
    end, { desc = "Recently open files / old files" })
    keymap.set("n", "<leader>f?", function()
      fzf.keymaps()
    end, { desc = "Find keymaps" })

    -- Additional useful fzf-lua specific keymaps
    keymap.set("n", "<leader>fh", function()
      fzf.help_tags()
    end, { desc = "Find help tags" })
    keymap.set("n", "<leader>ft", function()
      fzf.colorschemes()
    end, { desc = "Find colorschemes with preview" })
    keymap.set("n", "<leader>fq", function()
      fzf.quickfix()
    end, { desc = "Find quickfix entries" })
    keymap.set("n", "<leader>fl", function()
      fzf.loclist()
    end, { desc = "Find location list entries" })
  end,
}
