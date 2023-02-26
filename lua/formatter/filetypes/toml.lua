local M = {}

function M.taplo()
  local util = require("formatter.util")
  return {
    exe = "taplo",
    args = { "fmt", "--stdin-filepath", util.escape_path(util.get_current_buffer_file_path()),"-" },
    stdin = true,
    try_node_modules = true,
  }
end

return M
