local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.remove_trailing_whitespace = util.withl(defaults.sed, "[ \t]*$")

M.remove_trailing_whitespace_sd = util.withl(defaults.sd, "[ \t]*$")

return M
