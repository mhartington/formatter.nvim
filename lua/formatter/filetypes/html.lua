local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.prettier = util.copyf(defaults.prettier)

M.prettierd = util.copyf(defaults.prettierd)

M.prettydiff = util.withl(defaults.prettydiff, "html")

function M.tidy()
  return {
    exe = "tidy",
    args = { "-quiet" },
    try_node_modules = true,
  }
end

function M.htmlbeautify()
  return {
    exe = "html-beautify",
    stdin = 1,
  }
end

return M
