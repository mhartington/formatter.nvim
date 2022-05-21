local M = {}

local util = require "formatter.util"

M.values = _FormatterConfigurationValues or {}

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
