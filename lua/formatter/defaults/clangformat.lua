local util = require "formatter.util"

return function()
  return {
    exe = "clang-format",
    args = {
      '-style="{IndentWidth: ' .. vim.api.nvim_buf_get_option(0, "tabstop") .. '}"',
      "-assume-filename",
      util.escape_path(util.get_current_buffer_file_name()),
    },
    stdin = true,
    try_node_modules = true,
  }
end
