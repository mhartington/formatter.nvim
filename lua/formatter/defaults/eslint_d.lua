local util = require "formatter.util"

return function()
  return {
    exe = "eslint_d",
    args = {
      "--stdin",
      "--stdin-filename",
      util.escape_path(util.get_current_buffer_file_path()),
      "--fix-to-stdout",
    },
    stdin = true,
    try_node_modules = true,
  }
end
