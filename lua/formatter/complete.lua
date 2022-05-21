local config = require "formatter.config"

local M = {}

function M.complete(args)
  local filetype = vim.bo.filetype
  local formatters = config.values.filetype[filetype]
  if type(formatters) ~= "table" then
    return {}
  end

  local input, _, _ = unpack(args)
  local configsToRun = {}
  for _, val in ipairs(formatters) do
    local tmp = val()
    local exe = tmp.exe
    if string.match(exe, input) then
      table.insert(configsToRun, exe)
    end
  end
  return configsToRun
end

return M
