local util = require "formatter.util"

return function()
  return {
    exe = "clang-format",
    args = {
      "-assume-filename",
      "$FILE_PATH",
    },
    stdin = true,
    try_node_modules = true,
  }
end
