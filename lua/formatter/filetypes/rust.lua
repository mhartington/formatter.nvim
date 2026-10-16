local M = {}

function M.rustfmt()
  return {
    exe = "rustfmt",
    stdin = true,
  }
end

return M
