local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.prettier = util.copyf(defaults.prettier)

M.prettierd = util.copyf(defaults.prettierd)

return M
