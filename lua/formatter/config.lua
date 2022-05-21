local util = require "formatter.util"

local M = {}

FORMATTER_CONFIG_VALUES = FORMATTER_CONFIG_VALUES or {}
M.values = FORMATTER_CONFIG_VALUES or {}

function M.set_defaults(defaults)
  defaults = defaults or {}
  M.values = vim.tbl_extend("force", { filetype = {} }, defaults)
end

M.set_defaults()

function M.formatters_for_filetype(filetype)
  if type(filetype) ~= "string" then
    return {}
  end

  return util.append(M.values.filetype[filetype], M.values.filetype["*"])
end

return M
