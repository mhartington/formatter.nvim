local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.djlint = util.copyf(defaults.djlint)

return M
