local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.fishindent = util.copyf(defaults.fishindent)

return M
