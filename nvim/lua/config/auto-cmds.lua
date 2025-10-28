-- Inspired from: https://github.com/MariaSolOs/dotfiles/blob/02e145c92d89280815071128f6c6eb4a59911730/.config/nvim/lua/autocmds.lua#L52-L62
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("bryaneduarr/last_location", { clear = true }),
  desc = "Go to the last location when opening a buffer",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"zz')
    end
  end,
})
