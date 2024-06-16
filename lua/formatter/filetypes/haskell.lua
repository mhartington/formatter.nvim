local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.stylish_haskell = util.copyf(defaults.stylish_haskell)
M.ormolu = util.copyf(defaults.ormolu)
M.fourmolu = util.copyf(defaults.fourmolu)

return M
