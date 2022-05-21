local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.remove_trailing_whitespace = util.withl(defaults.sed, "[ \t]*$")

return M
