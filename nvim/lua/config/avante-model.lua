-- Avante model status line integration.

local M = {}

-- Cache for the current model to avoid repeated config reads.
local current_model_cache = nil
local last_update_time = 0

-- Helper to get current model from Avante config.
local function get_avante_model_info()
  -- Cache for 1 second to avoid performance issues in status line.
  local current_time = vim.loop.hrtime() / 1e9
  if current_model_cache and (current_time - last_update_time) < 1 then
    return current_model_cache
  end

  local ok, avante_config = pcall(require, "avante.config")
  if not ok or not avante_config then
    current_model_cache = nil
    last_update_time = current_time
    return nil
  end

  -- Get the current provider.
  local provider = avante_config.provider or "unknown"

  -- Get the model for the current provider.
  local model = nil
  if avante_config.providers and avante_config.providers[provider] then
    model = avante_config.providers[provider].model
  end

  local result = {
    provider = provider,
    model = model or "default",
    display = model and (provider .. ":" .. model) or provider,
  }

  current_model_cache = result
  last_update_time = current_time
  return result
end

-- Public function to get the current Avante model for status line.
function M.get_model()
  local model_info = get_avante_model_info()
  return model_info and model_info.display or nil
end

-- Public function to get a formatted model string for status line.
function M.get_model_status()
  local model = M.get_model()
  return model and ("󰚩 " .. model) or ""
end

-- Function to invalidate cache (called when model changes).
function M.refresh_model()
  current_model_cache = nil
  last_update_time = 0
  -- Force status line update
  vim.cmd("redrawstatus")
end

-- Hook into Avante events to refresh model info when it changes.
local function setup_model_change_hooks()
  -- Create autocmds to detect when Avante model might change
  vim.api.nvim_create_autocmd("User", {
    pattern = "AvanteModelChanged",
    callback = M.refresh_model,
  })

  -- Also refresh when Avante config is reloaded.
  vim.api.nvim_create_autocmd("User", {
    pattern = "AvanteConfigReloaded",
    callback = M.refresh_model,
  })

  -- Hook into command completions to detect model changes.
  vim.api.nvim_create_autocmd("CmdlineLeave", {
    callback = function()
      local cmdline = vim.fn.getcmdline()
      if string.match(cmdline, "^AvanteModels") or string.match(cmdline, "^AvanteSwitchProvider") then
        -- Refresh after a short delay to allow model selection to complete
        vim.defer_fn(M.refresh_model, 200)
      end
    end,
  })

  -- Also refresh when entering Avante buffers in case model was changed.
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "Avante", "avante", "AvanteInput" },
    callback = M.refresh_model,
  })
end

-- Initialize hooks.
setup_model_change_hooks()

return M
