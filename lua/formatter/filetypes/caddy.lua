local M = {}

function M.caddy()
  return {
    exe = "caddy",
    args = { "fmt", "-w" },
    stdin = false,
  }
end

return M
