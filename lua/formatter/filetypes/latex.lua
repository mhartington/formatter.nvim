local M = {}

local util = require "formatter.util"
local defaults = require "formatter.defaults"

M.latexindent = util.copyf(defaults.latexindent)
M.tex_fmt = util.copyf(defaults.tex_fmt)

return M
