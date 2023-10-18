local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.remove_trailing_whitespace = util.withl(defaults.sed, "[ \t]*$")

M.substitute_trailing_whitespace = function()
    vim.cmd([[silent! :keeppatterns %s/\[ \t]+$//ge]])
end

return M
