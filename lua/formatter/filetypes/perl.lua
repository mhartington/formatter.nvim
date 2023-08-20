local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.perlimports = util.copyf(defaults.perlimports)

return M
