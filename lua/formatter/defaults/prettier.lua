local util = require "formatter.util"

return function(parser)
  if not parser then
    return {
      exe = "prettier",
      args = {
        "--stdin-filepath",
        "$FILE_PATH",
      },
      stdin = true,
      try_node_modules = true,
    }
  end

  return {
    exe = "prettier",
    args = {
      "--stdin-filepath",
      "$FILE_PATH",
      "--parser",
      parser,
    },
    stdin = true,
    try_node_modules = true,
  }
end
