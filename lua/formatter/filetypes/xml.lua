local M = {}

local util = require "formatter.util"

function M.xmllint()
  return {
    exe = "xmllint",
    args = {
      "--format",
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
  }
end

return M
