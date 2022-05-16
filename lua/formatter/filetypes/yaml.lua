local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.prettier = util.withl(defaults.prettier, "yaml")

M.prettierd = util.copyf(defaults.prettierd)

function M.pyaml()
  return {
    exe = "python3",
    args = { "-m", "pyaml" },
    stdin = true,
  }
end

return M
