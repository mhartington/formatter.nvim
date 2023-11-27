local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.perltidy = util.copyf(defaults.perltidy)

return M
