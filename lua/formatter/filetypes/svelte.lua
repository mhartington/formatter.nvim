local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.prettier = util.copyf(defaults.prettier)

return M
