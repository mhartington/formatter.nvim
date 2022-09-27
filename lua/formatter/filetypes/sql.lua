local M = {}

function M.pgformat()
  return {
    exe = "pg_format --inplace -",
    stdin = true,
  }
end

return M
