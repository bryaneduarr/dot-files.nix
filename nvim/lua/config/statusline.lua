-- Track the LSP progress.
local progress_status = {}

-- Spinner animation frames
local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_index = 1

-- Timer for spinner animation
local spinner_timer = nil

-- Get icons from config
local icons = require("config.icons")

-- Get mini.icons for file type icons
local mini_icons = require("mini.icons")

-- Show filename with file type icon (minimal approach)
_G.file_name_component = function()
  local filename = vim.fn.expand("%:t")

  -- If no filename, show [No Name]
  if filename == "" then
    return "[No Name]"
  end

  -- Get file type icon and highlight from mini.icons
  local file_icon = mini_icons.get("file", filename)

  -- Format with icon, highlight, and filename
  if file_icon then
    return string.format("%s %s", file_icon, filename)
  else
    return filename
  end
end

-- Word and character count component
_G.word_count_component = function()
  local mode = vim.api.nvim_get_mode().mode

  -- Check if we're in visual mode (selection)
  if mode == "v" or mode == "V" or mode == "" then
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines_selected = end_pos[2] - start_pos[2] + 1
    return string.format("%dL", lines_selected)
  end

  -- Get buffer content
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  -- Count words and characters
  local word_count = 0
  for word in content:gmatch("%S+") do
    word_count = word_count + 1
  end

  local char_count = #content

  return string.format("Wor:%d|Char:%d", word_count, char_count)
end

-- Store last diagnostic component value to avoid flicker in insert mode
local last_diagnostic_component = ""

-- Simple VCS status showing branch and changes
_G.vcs_status = function()
  local git_info = vim.b.gitsigns_status_dict

  if not git_info or git_info.head == "" then
    return ""
  end

  local status_parts = {}

  -- Branch name with icon and color
  table.insert(status_parts, string.format("%s", git_info.head))

  -- Changes count (modified, added, removed) with colors
  local changes = {}
  if git_info.added and git_info.added > 0 then
    table.insert(changes, string.format("+%d", git_info.added))
  end
  if git_info.changed and git_info.changed > 0 then
    table.insert(changes, string.format("~%d", git_info.changed))
  end
  if git_info.removed and git_info.removed > 0 then
    table.insert(changes, string.format("-%d", git_info.removed))
  end

  if #changes > 0 then
    table.insert(status_parts, string.format(" [%s]", table.concat(changes, " ")))
  end

  return table.concat(status_parts)
end

-- Create autocmd to track LSP progress for statusline updates.
-- Inspiration from: https://github.com/MariaSolOs/dotfiles/blob/30838ba4e6ba60334b8c2185d40eca8be02e8ff3/.config/nvim/lua/statusline.lua#L128-L154
vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("statusline_lsp_progress", { clear = true }),
  desc = "Update LSP progress in statusline",
  pattern = { "begin", "end" },
  callback = function(args)
    -- This should in theory never happen, but I've seen weird errors.
    if not args.data then
      return
    end

    -- Get the client and progress details.
    progress_status = {
      client = vim.lsp.get_client_by_id(args.data.client_id).name,
      kind = args.data.params.value.kind,
      title = args.data.params.value.title,
    }

    if progress_status.kind == "end" then
      progress_status.title = nil

      -- Stop spinner animation
      if spinner_timer then
        spinner_timer:stop()
        spinner_timer = nil
      end

      -- Wait a bit before clearing the status.
      vim.defer_fn(function()
        vim.cmd.redrawstatus()
      end, 3000)
    else
      -- Start spinner animation
      if not spinner_timer then
        spinner_timer = vim.loop.new_timer()
        spinner_timer:start(
          0,
          100,
          vim.schedule_wrap(function()
            spinner_index = spinner_index % #spinner_frames + 1
            vim.cmd.redrawstatus()
          end)
        )
      end

      vim.cmd.redrawstatus()
    end
  end,
})

--- Display the latest LSP progress message with spinner animation.
---@return string LSP
_G.lsp_progress = function()
  -- If no progress status is available, return an empty string.
  if not progress_status.client or not progress_status.title then
    return ""
  end

  -- Avoid noisy messages while typing.
  if vim.startswith(vim.api.nvim_get_mode().mode, "i") then
    return ""
  end

  -- Get current spinner frame
  local spinner = spinner_frames[spinner_index]

  -- Get LSP icon (using generic LSP icon)
  local lsp_icon = "󰒋" -- LSP icon

  return string.format("%s %s %s %s", spinner, lsp_icon, progress_status.client, progress_status.title)
end

--- Diagnostic counts in the current buffer with colors.
---@return string Formatted diagnostic component for statusline
_G.diagnostics_component = function()
  -- Lazy uses diagnostic icons, but those aren't errors per se.
  if vim.bo.filetype == "lazy" then
    return ""
  end

  -- Use the last computed value if in insert mode.
  if vim.startswith(vim.api.nvim_get_mode().mode, "i") then
    return last_diagnostic_component
  end

  local counts = vim.iter(vim.diagnostic.get(0)):fold({
    ERROR = 0,
    WARN = 0,
    HINT = 0,
    INFO = 0,
  }, function(acc, diagnostic)
    local severity = vim.diagnostic.severity[diagnostic.severity]
    acc[severity] = acc[severity] + 1
    return acc
  end)

  local parts = {}

  -- Add errors.
  if counts.ERROR > 0 then
    table.insert(parts, string.format("%s %d", icons.diagnostics.ERROR, counts.ERROR))
  end

  -- Add warnings.
  if counts.WARN > 0 then
    table.insert(parts, string.format("%s %d", icons.diagnostics.WARN, counts.WARN))
  end

  -- Add info and hints.
  if counts.INFO > 0 then
    table.insert(parts, string.format("%s %d", icons.diagnostics.INFO, counts.INFO))
  end

  if counts.HINT > 0 then
    table.insert(parts, string.format("%s %d", icons.diagnostics.HINT, counts.HINT))
  end

  last_diagnostic_component = table.concat(parts, " ")
  return last_diagnostic_component
end

-- Configure the minimal statusline:
-- Left: filename and buffer flags
-- Right: word/char count, diagnostics, LSP progress, git status
-- Call the avante configuration to show the current selected model in the status bar.
vim.opt.statusline =
  "%{v:lua.file_name_component()} %h%m%r%= %{v:lua.lsp_progress()} %{v:lua.vcs_status()} %{v:lua.diagnostics_component()} Ln:%l|Col:%c"
