local vim = vim

local M = {}

function M.setup(_)
  vim.api.nvim_err_write(
    [[
Formatter: The package name for formatter.nvim has changed.
Please update the latest name
require('format') to require('formatter')
  ]]
  )
end

return M
