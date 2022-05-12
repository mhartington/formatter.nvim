local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.uncrustify = util.withl(defaults.uncrustify, "CS")

M.clangformat = util.copyf(defaults.clangformat)

M.astyle = util.withl(defaults.astyle, "cs")

M.dotnetformat = function()
  return {
    exe = "dotnet",
    args = {
      "format",
      "whitespace",
      "--include",
    },
    stdin = false,
  }
end

return M
