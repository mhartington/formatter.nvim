local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.mixformat = util.copyf(defaults.mixformat)

return M
