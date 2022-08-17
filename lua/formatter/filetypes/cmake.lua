local M = {}

function M.cmakeformat()
  return {
    exe = "cmake-format",
    arg = { "-" },
    stdin = true,
  }
end

return M
