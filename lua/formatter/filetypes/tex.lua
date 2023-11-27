local M = {}

function M.latexindent()
  return {
    exe = "latexindent -",
    stdin = true,
  }
end

return M
