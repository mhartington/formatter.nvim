local M = {}

function M.taplo()
  local util = require("formatter.util")
  return {
    exe = "taplo",
    args = { "fmt", "--stdin-filepath", "$FILE_PATH","-" },
    stdin = true,
    try_node_modules = true,
  }
end

return M
