local util = require "formatter.util"

return function()
  return {
    exe = "prettierd",
    args = { "$FILE_PATH" },
    stdin = true,
  }
end
