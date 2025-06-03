local util = require "formatter.util"

return function()
  return {
    exe = "mix",
    args = {
      "format",
      "--stdin-filename",
      util.escape_path(util.get_current_buffer_file_path()),
      "-",
      "--stdin-filename",
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
  }
end
