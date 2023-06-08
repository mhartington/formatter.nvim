local M = {}

local util = require "formatter.util"

function M.erbformatter()
  return {
    exe = "erb-formatter",
    args = { util.escape_path(util.get_current_buffer_file_path()) },
    stdin = true,
  }
end

return M
