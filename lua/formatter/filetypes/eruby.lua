local defaults = require "formatter.defaults"
local util = require "formatter.util"

local M = {}

function M.erbformatter()
  return {
    exe = "erb-formatter",
    args = { util.escape_path(util.get_current_buffer_file_path()) },
    stdin = true,
  }
end

M.htmlbeautifier = util.copyf(defaults.htmlbeautifier)

return M
