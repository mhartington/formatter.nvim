local M = {}

FORMATTER_CONFIG_VALUES = FORMATTER_CONFIG_VALUES or {}
M.values = FORMATTER_CONFIG_VALUES or {}

function M.set_defaults(defaults)
  defaults = defaults or {}
  M.values = vim.tbl_extend("force", { filetype = {} }, defaults)
end

M.set_defaults()

return M
