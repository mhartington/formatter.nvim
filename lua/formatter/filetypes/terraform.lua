local M = {}

function M.terraformfmt()
  return {
    exe = "terraform",
    args = { "fmt", "-" },
    stdin = true,
  }
end

return M
