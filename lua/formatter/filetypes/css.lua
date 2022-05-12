local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.prettydiff = util.withl(defaults.prettydiff, "css")

M.prettier = util.withl(defaults.prettier, "css")

M.prettierd = util.copyf(defaults.prettierd)

M.eslint_d = util.copyf(defaults.eslint_d)

function M.stylefmt()
  return {
    exe = "stylefmt",
    stdin = 1,
    try_node_modules = true,
  }
end

function M.cssbeautify()
  return {
    exe = "css-beautify",
    stdin = 1,
  }
end

function M.csscomb()
  return {
    exe = "csscomb",
    try_node_modules = true,
  }
end

return M
