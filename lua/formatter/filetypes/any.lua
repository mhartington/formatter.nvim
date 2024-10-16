local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.remove_trailing_whitespace = util.withl(defaults.sed, "[ \t]*$")

M.substitute_trailing_whitespace = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))

  vim.cmd [[silent! :keeppatterns %s/[ \t]\+$//ge]]

  -- Restore cursor position without going out of bounds
  local lastline = vim.fn.line "$"
  if line > lastline then
    line = lastline
  end
  vim.api.nvim_win_set_cursor(0, { line, col })
end

return M
