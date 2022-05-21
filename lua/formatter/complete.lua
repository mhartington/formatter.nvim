local M = {}

local util = require "formatter.util"

function M.complete(args)
  local filetype = vim.bo.filetype
  local formatters = util.formatters_for_filetype(filetype)

  local input, _, _ = unpack(args)
  local completion = {}
  for _, formatter_function in ipairs(formatters) do
    local formatter = formatter_function()
    local exe = formatter.exe
    if string.match(exe, input) then
      table.insert(completion, exe)
    end
  end
  return completion
end

return M
