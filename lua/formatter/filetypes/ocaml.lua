local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.ocamlformat = util.copyf(defaults.ocamlformat)

return M
