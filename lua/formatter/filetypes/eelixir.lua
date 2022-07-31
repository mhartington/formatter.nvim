local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.prettier = util.withl(defaults.prettier, "html")

return M
