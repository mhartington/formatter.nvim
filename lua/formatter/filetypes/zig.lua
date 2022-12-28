local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.zigfmt = util.copyf(defaults.zigfmt)
M.zigfmt_astcheck = util.copyf(defaults.zigfmt_astcheck)

return M
