local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.zigfmt = util.copyf(defaults.zigfmt)

return M
