local M = {}

function M.xmlformat()
  return {
    exe = "xmlformat",
    args = { "-" },
    stdin = true,
  }
end

return M
