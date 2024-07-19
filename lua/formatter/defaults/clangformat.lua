local util = require "formatter.util"

return function()
  return {
    exe = "clang-format",
    stdin = true,
    try_node_modules = true,
  }
end
