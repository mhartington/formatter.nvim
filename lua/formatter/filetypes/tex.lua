local M = {}

local util = require "formatter.util"
local defaults = require "formatter.defaults"

function M.latexindent()
  return {
    exe = "latexindent -",
    stdin = true,
  }
end
M.tex_fmt = util.copyf(defaults.tex_fmt)

return M
