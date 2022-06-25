local util = require "formatter.util"
return function()
  return {
    exe = "ocamlformat",
    args = {
      "--enable-outside-detected-project",
      util.escape_path(util.get_current_buffer_file_name()),
    },
    stdin = true,
  }
end
