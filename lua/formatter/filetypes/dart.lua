local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.dartformat = util.copyf(defaults.dartformat)

return M
