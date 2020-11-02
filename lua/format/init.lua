local vim = vim
local config = require("format.config")
local M = {}
function M.setup(o)
  config.set_defaults(o)
  vim.api.nvim_command(
    'command! -nargs=? -range=% -bang Format lua require"format.formatter".format("<bang>", <q-args>, <line1>, <line2>)'
  )
end

return M
