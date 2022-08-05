local M = {}

function M.rustfmt()
  return {
    exe = "rustfmt --edition 2021",
    stdin = true,
  }
end

return M
