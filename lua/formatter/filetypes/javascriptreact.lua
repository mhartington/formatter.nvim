local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.jsbeautify = util.copyf(defaults.jsbeautify)

M.prettydiff = util.withl(defaults.prettydiff, "javascript")

M.esformatter = util.copyf(defaults.esformatter)

M.prettier = util.copyf(defaults.prettier)

M.prettierd = util.copyf(defaults.prettierd)

M.prettiereslint = util.copyf(defaults.prettiereslint)

M.eslint_d = util.copyf(defaults.eslint_d)

M.standard = util.copyf(defaults.standard)

M.denofmt = util.copyf(defaults.denofmt)

M.semistandard = util.copyf(defaults.semistandard)

M.clangformat = util.copyf(defaults.clangformat)

return M
