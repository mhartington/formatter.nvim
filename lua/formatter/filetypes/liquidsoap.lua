local M = {}

function M.liquidsoap_prettier()
  return {
    exe = "liquidsoap-prettier",
    args = {"--write"},
    stdin = false
  }
end

return M
