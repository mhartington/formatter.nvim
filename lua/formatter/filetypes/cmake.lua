local M = {}

function M.cmakeformat()
  return {
    exe = "cmake-format",
    stdin = true,
  }
end

return M
