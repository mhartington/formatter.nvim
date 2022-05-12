local util = require "formatter.util"

return function(parser)
  if not parser then
    return {
      exe = "prettier-eslint",
      args = {
        "--stdin",
        "--stdin-filepath",
        util.escape_path(util.get_current_buffer_file_path()),
      },
      stdin = true,
      try_node_modules = true,
    }
  end

  return {
    exe = "prettier-eslint",
    args = {
      "--stdin",
      "--stdin-filepath",
      util.escape_path(util.get_current_buffer_file_path()),
      "--parser",
      parser,
    },
    stdin = true,
    try_node_modules = true,
  }
end
