local M = {}

local util = require "formatter.util"
local defaults = require "formatter.defaults"

M.latexindent = util.copyf(defaults.latexindent)

return M
