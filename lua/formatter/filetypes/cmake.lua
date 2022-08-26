local M = {}

function M.cmakeformat()
  return {
    exe = "cmake-format",
    args = { "-" },
    stdin = true,
  }
end

return M
