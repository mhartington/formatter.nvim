local vim = vim

local M = {
  setup = function(o)
    require('format.config').set_defaults(o)
    vim.api.nvim_command('command! -nargs=? -range=% -bang Format lua require"format.formatter".format(<q-args>, <line1>, <line2>)')
  end
}

return M
