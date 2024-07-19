local util = require "formatter.util"

return function()
  return {
    exe = "clang-format",
    stdin = false,
    try_node_modules = true,
  }
end
