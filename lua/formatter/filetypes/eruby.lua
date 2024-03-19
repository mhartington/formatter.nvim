local defaults = require "formatter.defaults"
local util = require "formatter.util"

local M = {}

function M.erbformatter()
  return {
    exe = "erb-formatter",
    args = { "$FILE_PATH" },
    stdin = true,
  }
end

M.htmlbeautifier = util.copyf(defaults.htmlbeautifier)

return M
