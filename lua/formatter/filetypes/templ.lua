local M = {}

function M.templfmt()
  return {
    exe = "templ",
    args = { "fmt" },
    stdin = true,
  }
end

return M
