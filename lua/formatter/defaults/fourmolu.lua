local util = require "formatter.util"

return function()
  return {
    exe = "fourmolu",
    args = {
      "--stdin-input-file",
      util.escape_path(util.get_current_buffer_file_name()),
    },
    stdin = true,
  }
end
