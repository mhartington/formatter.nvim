local M = {}

function M.shfmt()
  local shiftwidth = vim.opt.shiftwidth._value
  local expandtab = vim.opt.expandtab._value

  if not expandtab then
    shiftwidth = 0
  end

  return {
    exe = "shfmt",
    args = { "-i", shiftwidth },
    stdin = true,
  }
end

return M
