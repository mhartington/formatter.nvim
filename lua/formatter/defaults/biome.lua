local util = require "formatter.util"

return function()
  return {
    exe = "biome",
    args = {
        "format",
        "--stdin-file-path",
        "$FILE_PATH",
    },
    stdin = true,
  }
end
