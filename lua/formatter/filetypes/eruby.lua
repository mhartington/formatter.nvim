local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.htmlbeautifier = util.copyf(defaults.htmlbeautifier)

return M
