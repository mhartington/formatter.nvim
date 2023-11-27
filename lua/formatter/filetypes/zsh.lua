local util = require "formatter.util"
local M = {}

function M.beautysh()
  local shiftwidth = vim.opt.shiftwidth:get()
  local expandtab = vim.opt.expandtab:get()

  if not expandtab then
    shiftwidth = 0
  end

  return {
    exe = "beautysh",
    args = {
      "-i",
      shiftwidth,
      util.escape_path(util.get_current_buffer_file_path()),
    },
  }
end

return M
