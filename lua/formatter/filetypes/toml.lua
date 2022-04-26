local M = {}

function M.taplo()
  return {
    exe = "taplo",
    args = { "fmt", "-" },
    stdin = true,
    try_node_modules = true,
  }
end

return M
