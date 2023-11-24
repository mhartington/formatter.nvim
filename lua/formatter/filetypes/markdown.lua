local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.prettier = util.copyf(defaults.prettier)

M.prettierd = util.copyf(defaults.prettierd)

function M.denofmt()
  local denofmt = util.copyf(defaults.denofmt)()
  table.insert(denofmt.args, "--ext")
  table.insert(denofmt.args, "md")
  return denofmt
end

return M
