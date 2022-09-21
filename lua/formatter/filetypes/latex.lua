local M = {}

function M.latexindent()
  return {
    exe = "latexindent",
    args = {
      "-g",
      "/dev/null",
    },
    stdin = true,
  }
end

return M
