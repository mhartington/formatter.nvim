local M = {}

FORMATTER_CONFIG_VALUES = FORMATTER_CONFIG_VALUES
  or {
    log_level = vim.log.levels.WARN,
    logging = false,
    filetype = {},
  }
M.values = FORMATTER_CONFIG_VALUES

return M
