local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.phpcbf = util.copyf(defaults.phpcbf)

return M
