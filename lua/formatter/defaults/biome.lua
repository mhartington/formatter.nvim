local util = require "formatter.util"

return function()
  return {
    exe = "biome",
    args = {
        "format",
        "--stdin-file-path",
        util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
  }
end