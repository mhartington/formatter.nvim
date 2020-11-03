local vim = vim
local config = require "format.config"

local M = {}

function M.complete(args)
  local input, _, _ = unpack(args)
  local filetype = vim.fn.eval("&filetype")
  local formatters = config.values[filetype]
  local configsToRun = {}
  for name, _ in pairs(formatters) do
    if string.match(name, input) then
      configsToRun[name] = name
    end
  end
  return configsToRun
end

return M
