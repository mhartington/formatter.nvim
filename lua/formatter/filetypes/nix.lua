local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.alejandra = util.copyf(defaults.alejandra)
M.nixfmt = util.copyf(defaults.nixfmt)
M.nixpkgs_fmt = util.copyf(defaults.nixpkgs_fmt)

return M
