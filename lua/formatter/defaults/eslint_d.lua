local util = require "formatter.util"

return function()
  return {
    exe = "eslint_d",
    args = {
      "--stdin",
      "--stdin-filename",
      "$FILE_PATH",
      "--fix-to-stdout",
    },
    stdin = true,
    try_node_modules = true,
  }
end
