local M = {}

function M.rustfmt()
  return {
    exe = "rustfmt",
    args = { "--edition 2021" },
    stdin = true,
  }
end

return M
