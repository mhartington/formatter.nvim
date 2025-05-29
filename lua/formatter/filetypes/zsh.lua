local M = {}

function M.beautysh()
  local shiftwidth = vim.opt.shiftwidth:get()
  local expandtab = vim.opt.expandtab:get()

  if not expandtab then
    shiftwidth = 0
  end

  return {
    exe = "beautysh",
    args = {
      "-i",
      shiftwidth,
      "-",
    },
    stdin = true,
  }
end

return M
